{%- from "apache/map.jinja" import apache with context %}

include:
  - apache.install
  - apache.config
  - apache.service

{%- for module in apache.modules %}
  {%- if apache.modules.get(module).get(enabled, True) %}

{%- if module == 'passenger' %}

apache_passenger_package:
  pkg.installed:
  - name: libapache2-mod-passenger
  - require:
    - pkg: apache_packages

{%- elif module == 'php' %}

apache_php_package:
  pkg.installed:
  - name: {{ apache.mod_php }}
  - require:
    - pkg: apache_packages

{%- elif module == 'perl' %}

apache_perl_package:
  pkg.installed:
  - name: {{ apache.mod_perl }}
  - require:
    - pkg: apache_packages

{%- elif module == 'wsgi' %}

apache_wsgi_package:
  pkg.installed:
  - name: {{ apache.mod_wsgi }}
  - require:
    - pkg: apache_packages

{%- elif module == 'xsendfile' %}

apache_xsendfile_package:
  pkg.installed:
  - name: {{ apache.mod_xsendfile }}
  - require:
    - pkg: apache_packages

{%- elif module == 'auth_kerb' %}

apache_auth_kerb_package:
  pkg.installed:
  - name: {{ apache.mod_auth_kerb }}
  - require:
    - pkg: apache_packages

{%- endif %}

apache_module_{{module}}_enable:
  cmd.run:
    - name: a2enmod {{module}}
    - creates: /etc/apache2/mods-enabled/{{module}}.load
    watch_in:
      - service: apache_service
    require:
      - sls: apache.install

  {%- else %}

apache_module_{{module}}_disable:
  cmd.run:
    - name: a2dismod {{module}}
    - onlyif: test -f /etc/apache2/mods-enabled/{{module}}.load
    watch_in:
      - service: apache_service
    require:
      - sls: apache.install

  {%- endif %}
{%- endfor %}