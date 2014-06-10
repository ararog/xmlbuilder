xmlbuilder
==========

.NET XMLBuilder

! *.NET XML Builder*

A DSL to help on XML authoring, with this library you can create xml content with few lines of code, there's no need to use System.Xml classes, the XMLBuilder hides all complexity behind xml generation.

## Quickstart

To use XMLBuilder you just need to add the XMLBuilder.dll as project reference.

Here's a small example:

```
XMLBuilder builder = XMLBuilder.Start("persons")
    .E("person")
        .A("name", "Richard")
        .A("age","30")                    
        .E("contact")
            .A("type", "email")
            .T("richard@thisworld.com")
        .Up()
    .Up()
    .E("person")
        .A("name", "Rachel")
        .A("age","20")
        .E("contact")
            .A("type", "phone")
            .T("555-5555");
```

The example above will produce the following output:

```
    <?xml version="1.0" encoding="UTF-8"?>
    <persons>
        <person name="Richard" age="30">
               <contact type="email">richard@thisworld.com</contact>
        </person>       
        <person name="Rachel" age="20">
               <contact type="phone">555-5555</contact>
        </person>       
    </persons>   
```

## Credits

.NET XML Builder has been ported by Rogério Araújo (faces.eti.br)

## Kudos

Thanks to James Murty (www.jamesmurty.com), the author of java-xmlbuilder.
