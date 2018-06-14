(
//MIDIIn.connect;    // init for one port midi interface
MIDIIn.connectAll;

// register functions:
~noteOff = { arg src, chan, num, vel;    [num].postln; };
~noteOn = { arg src, chan, num, vel;    [chan,num,vel / 127].postln; };
~polytouch = { arg src, chan, num, vel;    [chan,num,vel / 127].postln; };
~control = { arg src, chan, num, val;    [chan,num,val].postln; };
~program = { arg src, chan, prog;        [chan,prog].postln; };
~touch = { arg src, chan, pressure;    [chan,pressure].postln; };
~bend = { arg src, chan, bend;        [chan,bend - 8192].postln; };
~sysex = { arg src, sysex;        sysex.postln; };
~sysrt = { arg src, chan, val;        [chan,val].postln; };
~smpte = { arg src, chan, val;        [chan,val].postln; };

MIDIIn.addFuncTo(\noteOn, ~noteOn);
MIDIIn.addFuncTo(\noteOff, ~noteOff);
/*
MIDIIn.addFuncTo(\polytouch, ~polytouch);
MIDIIn.addFuncTo(\control, ~control);
MIDIIn.addFuncTo(\program, ~program);
MIDIIn.addFuncTo(\touch, ~touch);
MIDIIn.addFuncTo(\bend, ~bend);
MIDIIn.addFuncTo(\sysex, ~sysex);
MIDIIn.addFuncTo(\sysrt, ~sysrt);
MIDIIn.addFuncTo(\smpte, ~smpte);
*/
)

//cleanup
(
MIDIIn.removeFuncFrom(\noteOn, ~noteOn);
MIDIIn.removeFuncFrom(\noteOff, ~noteOff);
MIDIIn.removeFuncFrom(\polytouch, ~polytouch);
MIDIIn.removeFuncFrom(\control, ~control);
MIDIIn.removeFuncFrom(\program, ~program);
MIDIIn.removeFuncFrom(\touch, ~touch);
MIDIIn.removeFuncFrom(\bend, ~bend);
MIDIIn.removeFuncFrom(\sysex, ~sysex);
MIDIIn.removeFuncFrom(\sysrt, ~sysrt);
MIDIIn.removeFuncFrom(\smpte, ~smpte);
)