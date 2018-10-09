{%- from "apache/map.jinja" import apache with context %}

include:
  - apache.install
  - apache.config
  - apache.service

{%- for module, params in apache.get('modules', {}).items() %}
  {%- if params.get('enabled', True) %}

apache_module_{{module}}:
  pkg.installed:
  - name: libapache2-mod-{{module}}
  - require:
    - pkg: apache_packages

apache_module_{{module}}_enable:
  cmd.run:
    - name: a2enmod {{module}}
    - creates: /etc/apache2/mods-enabled/{{module}}.load
    - watch_in:
      - service: apache_service
    - require:
      - sls: apache.install

  {%- else %}

apache_module_{{module}}_disable:
  cmd.run:
    - name: a2dismod {{module}}
    - onlyif: test -f /etc/apache2/mods-enabled/{{module}}.load
    - watch_in:
      - service: apache_service
    - require:
      - sls: apache.install

  {%- endif %}
{%- endfor %}
