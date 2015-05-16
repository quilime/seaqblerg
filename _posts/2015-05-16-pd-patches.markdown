---
layout: post
title:  "Patches"
date:   2015-05-16
categories: dev
---

This is an overview of the current patches in the synth, built with Pure Data (libpd) v0.46-6.

##### [main]

The top-level patch that is parsed by libpd on the c++ front end. This is where the DSP audio chain including the [clock], [wavetable] synth, all [voice]'s, and mixer are initialized.

![](media/outline/main-Screen Shot 2015-05-16 at 2.11.51 PM.png)

##### [clock]

The clock is built on a [phasor~] running at audiorate. We use a Beats Per Minute calculation to set the frequency. There are three distinct pulses:

  1. **Heartbeat** is the base clock. This triggers every time a 16 step pattern with a noteStep of 1 takes to go cycle 16 times, calculated from the BPM.
  2. **Step** represents the amount of time a single 16 step pattern with a noteStep of 1 takes to cycle one time.
  3. **Metro Blip** is a 4/4 pulse, representing quarter notes.

![](media/outline/clock-Screen Shot 2015-05-16 at 2.11.55 PM.png)

To extract control-rate information used in triggering events and whatnot, we use [edgem~], a patch that gives the ability to pass a multiplier to [edge~], used for measuring various fractions of time from the Heartbeat phasor.

![](media/outline/clock-edge-Screen Shot 2015-05-16 at 3.28.00 PM.png)

##### [wavetable]

The wavetable is the raw waveform arrays later used by [tabread~]. We create arrays 4096 values in length with via sinesum in a message, with the exception of Noise, which we generate via C++, as we have more control over random numbers.

![](media/outline/wavetable-Screen Shot 2015-05-16 at 2.12.06 PM.png)

##### [voice $1] 1 thru 8

Currently there are 8 static voices. There's a potential for more, we'll see how much overhead we have in the optimization phase. A voice is made up of a sequencer and a synth, which then gets piped through a mixer-track.

![](media/outline/voice-Screen Shot 2015-05-16 at 2.12.16 PM.png)

##### [sequencer]

The first component of the voice is the sequencer, which has two arrays that contain note and velocity pairs. 

![](media/outline/seaquencer-Screen Shot 2015-05-16 at 2.12.19 PM.png)

in [getPosition], we use clockPhase to calculate the position of the sequencer. This ensures that every sequencer is in sync. This is also where we apply swing and noteStep.

![](media/outline/get-position-Screen Shot 2015-05-16 at 2.12.25 PM.png)

##### [synth]

Now onto the juicy parts that make actual sound. 

![](media/outline/synth-Screen Shot 2015-05-16 at 2.14.37 PM.png)

Once we have the note and velocity pairs from the sequencer, they get handled by the [poly-tone~] patch. Here we see if we're set to polyphonic or mono, and do all the voice packing, handling, and distribution to the 8 voices. (Could be more in the future depending on overhead). When the synth is in a monophonic state, it only uses the first voice, and the rest are switched off.

![](media/outline/poly-tone-Screen Shot 2015-05-16 at 2.14.41 PM.png)

##### [tone~]

Inside [tone~] we the guts of what makes up each voice. After unpacking the note and velocity pairs, that data is used to trigger an ADSR, and frequencey envelope. Depending if "hold" is engaged sets if the release phase of the envelope gets triggered -- this is used in the Mono Synth.

![](media/outline/synth-tone-Screen Shot 2015-05-16 at 3.45.06 PM.png)

The wavetable uses whichever waveform type is selected, combined with the incoming note frequency, to generate a signal using [tabread~]

![](media/outline/synth-wavetable-Screen Shot 2015-05-16 at 3.45.10 PM.png)

The frequency envelope uses a noteOn event to start an attack phase which modifies the pitch of each note.

![](media/outline/pitch-env-Screen Shot 2015-05-16 at 3.45.24 PM.png)

##### [svf~] State Variable Filter

We utilize the [svf~] object packaged with Cyclone. It is a 4-type filter which generates the outputs for all filter types at once, allowing us to cross-fade between them.

![](media/outline/fx-svf-Screen Shot 2015-05-16 at 2.16.46 PM.png)

A filter envelope is triggered from note-attack to sweep the filter cutoff

![](media/outline/fx-svf-enc-Screen Shot 2015-05-16 at 2.16.48 PM.png)

We use [mix], based on the same concept of glm::mix, or lerp(), which linear interpolates filter values so they blend between envelope states if the cut or res are modified.

![](media/outline/mix-Screen Shot 2015-05-16 at 2.16.54 PM.png)

In order to implement a crossfader between all filter value types, another custom patch is created:

![](media/outline/fx-svfilter-crossfade-Screen Shot 2015-05-16 at 2.17.02 PM.png)


##### [switcher $1]

A switcher in every voice disabled DSP 2 seconds after the last note is released.

![](media/outline/voice-switcher-Screen Shot 2015-05-16 at 2.17.10 PM.png)

##### [mixer-track]

Finally, the audio is converted to stereo and mixed with balance and volume additionall, we bus the audio to an fx-send for later use in the master.

![](media/outline/voice-mixer-Screen Shot 2015-05-16 at 3.38.58 PM.png)

##### [mixer]

Finally, the mixer takes all the audio from each voice and mixes them down. Here we have another final filter on the master LR, and put them through a compressor and a limiter, and finally from here, the sound goes to the DAC.

![](media/outline/mixer-main0Screen Shot 2015-05-16 at 2.17.19 PM.png)

## Local Controls

Our local test-bed allows any value to be tested, note velocities and patterns randomly created, and effects tweaked. This screenshot is controlling only one synth (s1). The local controls also support midi i/o for external interfaces.

![](media/outline/local-Screen Shot 2015-05-16 at 4.02.46 PM.png)

A local mixer with graphical controls offers the ability to test output, fx bus, compressor settings, and fx controls.

![](media/outline/localmixer-Screen Shot 2015-05-16 at 4.03.58 PM.png)