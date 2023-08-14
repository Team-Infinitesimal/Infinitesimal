# Infinitesimal - an Infinity-inspired OutFox theme

![logo](https://raw.githubusercontent.com/dj505/Infinitesimal/main/Graphics/Logo/Logo%20(doubleres).png)

## [Discord server is now available for more development insights and discussion!](https://discord.gg/ex6e4jNm6s)

## About Infinitesimal
This theme is inspired by Pump It Up Infinity, an uncommon StepMania-based spin-off developed by Team Infinity and licensed by Andamiro. The current goals are to replicate the look and feel of Infinity while sprinkling in new additions and quality of life improvements, utilizing original assets when possible, bringing high performance + cross-platform support to the table with Project OutFox and widening the idea and accessibility of custom Pump It Up content.

## Requirements
* [Project OutFox Alpha 0.4.18.1 or newer](https://projectoutfox.com/downloads)

Older StepMania versions such as `5.0.12`, `5.1b2` and `5.1-new` are not supported due to the lack of maintenance to `pump/piu` and the engine in general. Support the developers from Team OutFox who are currently doing the heavy lifting!

## Installing
Since this theme is currently on a rolling release, we highly recommend downloading the theme through GitHub Desktop (or `git` for Linux users) and pull subsequent updates that are pushed to the repository. If you're unable to do so, you can also download from the `Code > Download ZIP` button on the main page and extract the .zip file to your OutFox [Themes](https://outfox.wiki/user-guide/config/folders/#themes) folder.

**If you are upgrading from a previous version by `Download ZIP`, fully delete the old folder first. Do not merge the new folder into the old.**

## Theme Features
* Accurate timing windows scoring and lifebar mechanics to K-Pump
* Additional timing windows available (StepMania, ITG, Infinity, Pro, Jump)
* Basic Mode can be accessed by starting a game with no profiles present, or by using the "Guest" profile
* Customizable appearance options and modifiers such as arrow size and rush
* Exit to title screen in home/event mode (hold down any red arrow while selecting a folder)
* Fully customizable background filters, choose to filter playfield only or the entire screen
* Measures and song progress display
* Multiply, Automatic and Constant scroll speeds
* Visualize chart information while selecting a song, previews are currently WIP

## Theme-Specific Toggles
The following features can be configured via the Infinitesimal Options submenu of the operator menu:
* Center Chart List: if there are less charts than the maximum visible number, the charts will be centered to the display.
* Chart Preview: preview the selected chart on the select music screen.
* Image Preview Only: videos will not be displayed while selecting a song, helps with performance on low-end hardware and/or memory usage.
* Pause With Select Button: use the button mapped to "Select" to open the pause menu during gameplay.
* Use Video Background: use a pre-rendered video for the animated theme background, requires restart.
* 3x Center to Exit Evaluation: press the center panel 3 times to exit the results screen like in official games, otherwise exit on one press.
* Show Big Difficulty Icon: display a larger icon while selecting a difficulty, aspect ratios higher than 4:3 only.
* Show UCS Charts: allow UCS charts to be selected, if a song has no standard charts disabling might not be effective to it.
* Show Quest Charts: allow Quest charts to be selected, if a song has no standard charts disabling might not be effective to it.
* Show Hidden Charts: allow Hidden charts to be selected, if a song has no standard charts disabling might not be effective to it.
* Autogen Basic Mode: allow the game to auto generate the list of songs for Basic Mode, disable this if you plan to use a handpicked list.
* Wrap Chart List Scrolling: when scrolling past the beginning or end of the chart list, wrap the current selection to the opposite end.

## Screenshots
![Title](https://github.com/dj505/Infinitesimal/assets/12992355/ef053e35-70b2-466c-8244-162ae017b61a)
![Profile](https://github.com/dj505/Infinitesimal/assets/12992355/25847cb5-3e9a-4b58-9177-71dec52e176f)
![BasicMode](https://github.com/dj505/Infinitesimal/assets/12992355/12dbe987-f561-4f14-9770-124b512ca761)
![SelectMusic](https://github.com/dj505/Infinitesimal/assets/12992355/67ed99c7-1ef0-4528-8bc2-18cc01daf765)
![Command](https://github.com/dj505/Infinitesimal/assets/12992355/e241a569-811d-42f4-800f-ddb031978698)
![Doubles](https://github.com/dj505/Infinitesimal/assets/12992355/9a28709c-28cf-4a53-9529-b01d58ac1904)
![Eval](https://github.com/dj505/Infinitesimal/assets/7433694/69703018-961c-4546-9259-0ebd23229318)


## Languages:
Currently, Infinitesimal supports the following languages:
* English
* Spanish
* Brazilian Portuguese
* Polish

## Additional Resources
If you're looking for assets such as more noteskins or folder icons from StepF2/P1, you can grab them [here](https://drive.google.com/drive/folders/1pO9rbaPUwTTDFuEo_4tX8S1BEwmfukeF?usp=sharing). Keep in mind these are independent from the theme and are only here for accessibility purposes to newcomers.

## Current Limitations and Issues
The theme currently has a few limitations that are beyond our reach. Here is a list of known limitations and issues:
* Some chart effects will be missing or broken from incomplete parsing
* Chart previews are very experimental - some styles might not load/show properly and your game might crash on edge cases
* Switching timing modes does not update the list of judgement graphics, simply reloading the current screen or changing screens will regenerate the list
* Infinitesimal has a few issues when running on Project OutFox Alpha V that are being investigated. Stick with standalone Alpha 4 LTS for the time being when playing Infinitesimal

Hopefully all of these should be gone soon with future Project OutFox developments and improvements!

## Special thanks
This theme wouldn't be here if it weren't for the help of the following people:
* JoseVarelaP (loads of code optimization and refactoring, suggestions and development assistance)
* Luizsan (creator of PIU Delta / member of Team Infinity and SSC, many notes and examples taken from his work)
* Squirrel and Jousway (development assistance, pump bug squashing)
* Accelerator/Rhythm Lunatic and Engine_Machiner (theme assistance)
* Bedrock Solid (music, suggestions and playtesting)
* SHRMP0, 4199, Enally and djgrs (suggestions and playtesting)
* octocd5, frondal/ar2k (Spanish localization) 
* CrackItUp group (original home of the theme's development)
* Team Infinity (setting a landmark in PIU's interface and graphics design)
* RGAB Community

And at last, you for trying out our theme!

