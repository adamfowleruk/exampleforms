/* Test */
ORBEON.jQuery( "#fr-view" ).prepend('\
<div class="switcher">\
<ul>\
    <li><a class="switch" href="#" rel="sco">Apply Form Stylesheet</a></li>\
    <li><a class="switch" href="#" rel="gds">Apply GDS Stylesheet</a></li>\
    <li><a class="switch" href="#" rel="">Apply Default Stylesheet</a></li>\
</ul>\
</div>' );

ORBEON.jQuery('.switch').click(function()
{
  ORBEON.jQuery("html").removeClass().addClass( ORBEON.jQuery(this).attr('rel') );
});
