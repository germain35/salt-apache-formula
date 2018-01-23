{%- from "apache/map.jinja" import apache with context %}

include:
  - apache.install
  - apache.config
  - apache.mpm

apache_service:
  service.running:
    - name: {{ apache.service }}
    - enable: {{ apache.service_enabled }}
    - reload: {{ apache.service_reload }}
    - require:
        - pkg: apache_packages
