{%- from "apache/map.jinja" import apache with context %}

include:
  - apache.install
  - apache.config
  - apache.mpm
  - apache.module
  - apache.service
