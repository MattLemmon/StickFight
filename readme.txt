_________________________________________________________________

                         S T I C K F I G H T     

Requires Ruby

$ gem install bundler
$ bundle install
$ ruby main.rb

Detailed installation instructions are included below.
_________________________________________________________________

                           CONTROLS

Mouse:    Left click and drag to select
          Right click to move

Spaebar:  Selected players attack the nearest opponent

V, B:     Selected players build buildings

ASDW:     Move this player around to see the viewport environment

Extra Controls:  I J K L => music controls

                 P => from the Pause menu you can return to the Main Menu

                 Z => press Z at any time for a gamestate status log
                      (print message to console)
_________________________________________________________________

                    QUICK INSTALL (Requires Ruby)

  $ git clone git@github.com:MattLemmon/StickFight.git
  $ cd StickFight
  $ gem install bundler      # (if needed)
  StickFight$ bundle install
  StickFight$ ruby main.rb

of if you prefer manual gem install (instead of bundle):

  $ gem install gosu -v 0.7.48
  $ gem install chingu

If you don't have git installed, you can copy the repo manually at
https://github.com/mattlemmon/StickFight by clicking on the "Download
Zip" link at the right side of the screen toward the bottom.

_________________________________________________________________

                  DETAILED INSTALL (If you don't have Ruby)

WINDOWS:

If you are on Windows, download the Ruby-Installer(version 1.9.3),
from rubyinstaller.org.

You want version 1.9.3 (not 2.0.0, which is still in "semi-beta").

Here is the direct link to download the installer:

http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-1.9.3-p448.exe?direct 

When you run the installer, click all three boxes for install
options, unless you have reason to do otherwise.

Once Ruby is installed, go to your Start menu, the go to All 
Programs -> Ruby-1.9.3 -> Command Prompt with Ruby.

Open Command Prompt with Ruby.

In Command Prompt with Ruby, you can try out `ruby -v` and `irb`
if you want.

Next you should:

Clone from github: https://github.com/mattlemmon/StickFight.git
(If you do not have git installed, just click on the "Download
Zip" link - right side of screen toward the bottom.)

Then `cd` into the StickFight folder. Install bundler by executing
`gem install bundler`. Then execute `bundle install`. This will install
two gems: Gosu (version 0.7.48), Chingu, and possibly a few dependencies as well.

Once the gems are installed, execute:

$ ruby main.rb

If you checked the boxes during install, you should also be able to 
simply double-click on the `main.rb` file in the StickFight folder.

Enjoy!


MAC:

Note: Gosu works on Mac OSX 10.5, 10.6, 10.7, and 10.8. It does
NOT (yet) work on 10.9 Mavericks.

If you are on a Mac, you will need Xcode 4+ or DeveloperTools.
Xcode and DeveloperTools are included on the Mac OSX install DVD.
If you do not have your install DVD, Xcode can also be downloaded 
from the App Store. It is a large download. You can also download from
https://developer.apple.com -> Member Center (requires registration).

In Xcode, be sure to install the Command Line Tools (in Preferences).

Ruby can be installed using Homebrew.

For a more robust install, use RVM (Ruby Version Manager).
Follow the instructions in this excellent tutorial:

http://net.tutsplus.com/tutorials/ruby/how-to-install-ruby-on-a-mac/

In the tutorial, you will be activating Ruby version 1.9.2, which is
perfect. Ruby version 1.9.2 is the one you should ideally go with.
If you want you can use 1.9.3 instead, but 1.9.2 is probably better
to start with. It really shouldn't make a difference either way.

Once Ruby is installed, you can try it out in Terminal with
`ruby -v` and `irb` if you want.

The next thing to do is to install bundler with the following command:
$ gem install bundler

Next you should:

Clone from github: https://github.com/mattlemmon/StickFight.git
(If you do not have git installed, just click on the "Download
Zip" link - right side of screen toward the bottom.)

Once you have copied the git repo, `cd` into the StickFight folder
and execute `bundle install`. This will install two gems: Gosu (version 0.7.48)
and Chingu, and possibly a few dependencies as well.


Then `cd` into the StickFight folder. Install bundler by executing
`gem install bundler`. Then execute `bundle install`. This will install
two gems: Gosu (version 0.7.48), Chingu, and possibly a few dependencies as well.


Once the gems are installed, execute:

$ ruby main.rb

Enjoy!

Additional install information:
https://github.com/jlnr/gosu/wiki/Getting-Started-on-OS-X
(scroll down past the C++ instructions until you find the Ruby
instructions)


LINUX:

If you're on Linux, then you will need to install RVM. I will
provide detailed instructions on this in the future, but for the
present moment, you will need to look for it on google.

Once Ruby is installed, you can try it out in Terminal with
`ruby -v` and `irb` if you want.

On Linux, you will need to install the dependecies required for
your system (Ubutnu, Debian, etc.):

https://github.com/jlnr/gosu/wiki/Getting-Started-on-Linux

Next you should:

Clone from github: https://github.com/mattlemmon/StickFight.git
(If you do not have git installed, just click on the "Download
Zip" link - right side of screen toward the bottom.)

Then `cd` into the StickFight folder and execute `bundle install`.
This will install two gems: Gosu and Chingu, and possibly a few
dependencies as well.

Once the gems are installed, execute:

$ ruby main.rb

_________________________________________________________________


       See more about Gosu and Chingu at libgosu.org

_________________________________________________________________


Attribution for Sound Effects and Music is included in the audio
information properties of each .ogg file.

_________________________________________________________________