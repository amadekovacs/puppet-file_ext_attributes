# Extended Attributes on Puppet file resources #

Have you ever wanted to set an extended attribute on a puppet managed
file resource? Well now you can!

    file { '/tmp/extattr':
      ensure => 'present',
      content => 'testy',
      mode    => '0644',
      extattr => 'myattr=myattrvalue',
    }

You can then confirm the attribute was applied with 

    $ getfattr -d /tmp/extattr
    ...
    myattr=myattrvalue

## Implementation

This extension of an existing type and provider is deployed
within a module and uses rubys open nature to add additional properties
to a type with `Puppet::Type.type(:file).newproperty(:extattr)`. Full
implementation details and technical explanations will follow in a
couple of blog posts that we'll link to from here.

Much of this code is the result of an evening worth of puppet internals
exploration and the brilliance of @richardc - some of the approaches
used in these sample extension modules may be incorrect assumptions or
change heavily as we go further back in to the code base but these
extensions hopefully prove that extending the core types is both
possible and desirable.

## Deployment

Install this code as you would any other module and then, if you have a puppet master, restart it.

## Notes

 * This property calls out to the getfattr and setfattr commands
   and assumes that they are installed and in the path
 * The file system contain the target of the file resource requires support for extended attributes
 * I've only tested this on linux
 * we only support attributes in the 'user' namespace
