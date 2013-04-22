SpreeTheme
==========

New frontend of spree, user could easy modify theme or add new theme. It is not working now!

how it work
-----------
designer
0. new theme
1. design theme
2. publish completed theme.  generate themeN/versionN.html.erb
3. theme is viewable by public.  shops/shop_id/themeN/    

backend
1. user browse available themes, snapshot or live demo.
2. import preferred theme
*3. preview it. Do not support it now, find a clean way support tld/admin/add_to_cart first. 
4. apply it to frontend

requirement
  admin.sometld/... is for user preview,   ex. admin.somtld/some_taxon  
  www.sometld/... is for customer,         ex. www.sometld/some_taxon

how roles get layout?
---------------------
designer: get current editing template
customer: get layout from current site 

path
----

customer view product list              -> www.tld/tid    
customer view product detail            -> www.tld/tid/pid
designer design product list page       -> www.tld/tid
designer design product detail page     -> www.tld/tid/pid
admin manage site                       -> www.tld/admin/...   

user login                              -> www.tld/admin/

customer view live template demo        -> templates.dalianshops.com
customer browse published template list -> www.tld/admin/template_themes/



Example
=======

Example goes here.

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test_app
    $ bundle exec rspec spec

Copyright (c) 2013 [name of extension creator], released under the New BSD License
