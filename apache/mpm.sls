{%- from "apache/map.jinja" import apache with context %}

include:
  - apache.install
  - apache.config
  - apache.service

{%- set mpm_modules = ['event', 'prefork', 'worker'] %}

# MPM module
{%- for mpm_module in mpm_modules %}
  {%- if mpm_module != apache.mpm_module|lower %}
apache_disable_mpm_{{mpm_module}}:
  cmd.run:
    - name: a2dismod {{mpm_module}}
    - unless: test -f /etc/apache2/mods-enabled/{{apache.mpm_module|lower}}.load
    - require_in:
      - file: apache_module_mpm
  {%- endif %}
{%- endfor %}

apache_module_mpm_{{apache.mpm_module|lower}}:
  file.managed:
    - name: {{ apache.mods_dir|path_join('mpm_' ~ apache.mpm_module|lower ~ '.conf') }}
    - source: salt://apache/files/mpm_{{ apache.mpm_module|lower }}.conf.jinja
    - template: jinja
    - user: root
    - mode: 644
    - watch_in:
      - service: apache_service
    - require:
      - sls: apache.install
  cmd.run:
    - name: a2enmod mpm_{{apache.mpm_module|lower}}
    - creates: /etc/apache2/mods-enabled/{{apache.mpm_module|lower}}.load
