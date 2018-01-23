{%- from "apache/map.jinja" import apache with context %}

include:
  - apache.install
  - apache.config
  - apache.mpm
  {%- if apache.modules is defined %}
  - apache.module
  {%- endif %}
  {%- if apache.sites is defined %}
  - apache.site
  {%- endif %}
  - apache.service
