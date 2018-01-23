{%- from "apache/map.jinja" import apache with context %}

{%- if apache.sites is defined %}
  {%- for site, params in apache.sites.iteritems() %}
apache_site_{{site}}:
  file.managed:
    - name: {{ apache.conf_dir }}/sites-available/{{site}}.conf
    - source: {{ params.source }}
    {%- if params.source_hash is defined %}
    - source_hash: {{ params.source_hash }}
    {%- endif %}
    - template: jinja
    - defaults: {{ params.get('settings', {}) }}
    - makedirs: True
    - user: root
    - mode: 644
    - watch_in:
      - service: apache_service

    {%- if params.get('enabled', True) %}
apache_enable_site_{{site}}:
  file.symlink:
    - name: {{ apache.conf_dir }}/sites-enabled/{{params.get('prefix', '')}}{{site}}.conf
    - target: {{ apache.conf_dir }}/sites-available/{{site}}.conf
    - makedirs: True
    - require:
      - file: apache_site_{{site}}
    - watch_in:
      - service: apache_service
    {%- endif %}
  {%- endfor %}
{%- endif %}
