{%- from "apache/map.jinja" import apache with context %}

{%- if apache.disable_default_site %}
apache_disable_default_site:
  cmd.run:
    - name: a2dissite 000-default
    - onlyif: test -f /etc/apache2/sites-enabled/000-default.conf
{%- endif %}

{%- if apache.sites is defined %}
  {%- for site, params in apache.sites.iteritems() %}
apache_site_{{site}}:
  file.managed:
    - name: {{ apache.sites_dir }}/{{params.get('prefix', '')}}{{site}}.conf
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
  cmd.run:
    - name: a2ensite {{params.get('prefix', '')}}{{site}}.conf
    - creates: /etc/apache2/sites-enabled/{{params.get('prefix', '')}}{{site}}.conf
    - require:
      - file: apache_site_{{site}}
    - watch_in:
      - service: apache_service

    {%- endif %}
  {%- endfor %}
{%- endif %}
