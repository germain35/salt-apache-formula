{%- from "apache/map.jinja" import apache with context %}

include:
  - apache.install
  - apache.service

{%- if apache.config.ports is defined %}
apache_ports_config:
  file.managed:
    name: {{ apache.ports_conf_file }}
    source: salt://apache/files/ports.conf.jinja
    template: jinja
    user: root
    mode: 644
    watch_in:
      - service: apache_service
    require:
      - sls: apache.install
{%- endif %}

apache_security_config:
  file.managed:
    name: {{ apache.security_conf_file }}
    source: salt://apache/files/security.conf.jinja
    template: jinja
    user: root
    mode: 644
    watch_in:
      - service: apache_service
    require:
      - sls: apache.install
  cmd.run:
    - name: a2enconf security

apache_env:
  file.managed:
    name: {{ apache.env_file }}
    source: salt://apache/files/envvars.jinja
    template: jinja
    user: root
    mode: 644
    watch_in:
      - service: apache_service
    require:
      - sls: apache.install