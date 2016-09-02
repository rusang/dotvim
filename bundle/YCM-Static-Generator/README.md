# YCM-Static-Generator
This is a simple stupid script which generates ```.ycm_extra_con.py``` for YouCompleteMe.

It works without any dependencies but only support some basic flags.
It is so stupid that you must add precompile definitions manually.
But I think the most necessary feature for this generator is seeking for include directories.

## Installation
Add ```NeoBundle 'jicong/YCM-Static-Generator'``` to your vimrc (or the equivalent for your plugin manager).

## Usage
Run ```./simple_ycm_generator.sh PROJECT_DIRECTORY```, where ```PROJECT_DIRECTORY``` is the root directory of your project.

## Documentation & Support
Supported Features(Run ```./simple_ycm_generator.sh -h``` to see the details.)

* Add include directories
* Add exclude directories
* Add precompile definitions

You can also invoke it from within Vim using the ```:GenerateConfig``` commands to generate a config file for the directory which the current file is in. This command accept the same arguments as ```./simple_ycm_generator.sh```, but do not require the project directory to be specified.
