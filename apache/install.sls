{%- from "apache/map.jinja" import apache with context %}

{%- if apache.manage_user %}
apache_user:
  user.present:
    - name: {{ apache.user }}
    - gid: {{ apache.group }}
    - fullname: 'apache2 user'
    - shell: /usr/sbin/nologin
    - home: {{ apache.www_dir }}
    - createhome: False
    - empty_password: True
    - system: True
    - require_in:
      - pkg: apache_packages
{%- endif %}

apache_packages:
  pkg.installed:
    - pkgs: {{ apache.pkgs }}
