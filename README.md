# Demos for the talk "Introduction to Nerves"

This repo contains 5 demos I presented at my talk "Introduction to Nerves"
at the Elixir Language Milan Meetup, on May 20th 2025.

**Warning**: the documentation for these demos is a work-in-progress and, as such, quite incomplete.

If you need clarifications with any of the steps to build or run the demos, please [create an issue on GitHub](https://github.com/csarnataro/nerves_talk/issues).


1. **Blinky**
    An advanced version of the classical "Blink", the Hello World of embedded system.

    This version blinks a LED showing a Morse encoded message.

    For further details, check out the code at [./blinky](./blinky/).

2. **Hello Nerves**

    Simple project created with the Nerves generator at 
    https://github.com/nerves-project/nerves_bootstrap

    Code available at [./hello_nerves](./hello_nerves/).


3. **Livebook + Liveview with Nerves** 

    This demo contains two different apps, grouped together as a "poncho" app:

    * [./nerves_livebook](./nerves_livebook/) is a Livebook application running on a Raspberry Pi 4.
    
        A custom livebook, created specifically for this talk, has been included in the firmware. 
        The livebook shows tempereratures measured with a TMP36 sensor on a VegaLite chart.
    
        See [./nerves_livebook](./nerves_livebook/).

    * [./ui](./ui) is a Phoenix/Liveview app to show the slides used in the talk, plus a dashboard to
        edit the slides in sqlite database.

    For more details on the "Poncho" approach in Nerves, see https://embedded-elixir.com/post/2017-05-19-poncho-projects/

4. **Pomodoro Timer**

    A Pomodoro Timer implemented with `:gen_statem`. The current state is shown on a 0.96" OLED screen 
    and using a small Lego arrow on a panel.

    [./pomodoro_timer](./pomodoro_timer/)


## Slides

The slides I used in the talk are available [in Italian](./slides/Nerves%20Talk%20·%20Slides%20-%20it.pdf) and 
[in English](./slides/Nerves%20Talk%20·%20Slides%20-%20en.pdf)


## Reference

* https://hexdocs.pm/nerves/getting-started.html
