// local machine
n = NetAddr("127.0.0.1"); // BROADCAST Receiver (anders klappt es nicht :( )
n = NetAddr("127.0.0.1", 1234);

OSCFunc.newMatching({|msg, time, addr, recvPort| msg.postln}, '/ping', n); // path matching


// senden zum Testen
m = NetAddr("127.0.0.1", 57120); // loopback
m = NetAddr("127.0.0.1", 57121); // loopback
m.sendMsg("/ping", "Hello App 1");


// weg damit
(
n.free;
m.free;
)

////////////////////////////////////////////////////////////////
// KLANGBEISPIELE
////////////////////////////////////////////////////////////////

{ SinOsc.ar(XLine.kr(2000, 200), 0, 0.5) }.play;
play({ Klang.ar(`[ [800, 1000, 1200], [0.3, 0.3, 0.3], [pi, pi, pi]], 1, 0) * 0.4});
play({ Klang.ar(`[ [800, 1000, 1200], nil, nil], 1, 0) * 0.25});
play({ Klang.ar(`[ Array.rand(12, 600.0, 1000.0), nil, nil ], 1, 0) * 0.05 });


(
{
loop({
    play({
        Pan2.ar(Klang.ar(`[ Array.rand(12, 200.0, 2000.0), nil, nil ], 1, 0), 1.0.rand)
             * EnvGen.kr(Env.sine(4), 1, 0.02, doneAction: 2);
    });
    2.wait;
})
}.fork;
)

// Multichannel Expansion
(
{
loop({
    play({
        var nPartials = 12, nChans = 5, n = nPartials * nChans;
        Splay.ar(Klang.ar(`[ { { rrand(200.0, 2000.0) } ! nPartials } ! nChans, nil, nil ], 1, 0))
             * EnvGen.kr(Env.sine(4), 1, 0.02, doneAction: 2);
    });
    2.wait;
})
}.fork;
)


// modulate the frequency with an exponential ramp
{ SinOsc.ar(XLine.kr(2000, 200), 0, 0.5) }.play;

// more complex frequency modulatation
{ SinOsc.ar(SinOsc.ar(XLine.kr(1, 1000, 9), 0, 200, 800), 0, 0.25) }.play;

// phase modulation (see also PMOsc)
{ SinOsc.ar(800, SinOsc.ar(XLine.kr(1, 1000, 9), 0, 2pi), 0.25) }.play;


// BLIP

// modulate frequency
{ Blip.ar(XLine.kr(20000,200,6),100,0.2) }.play;

// modulate numharmonics
{ Blip.ar(200,Line.kr(1,100,20),0.2) }.play;


// Chorus OSC

(
b = Buffer.alloc(s, 512, 1, {arg buf; buf.sine1Msg(1.0/[1,2,3,4,5,6,7,8,9,10])});
{ COsc.ar(b.bufnum, 200, 0.7, 0.25) }.play;
)

// FORMANT


// modulate fundamental frequency, formant freq stays constant
{ Formant.ar(XLine.kr(400,1000, 8), 2000, 800, 0.125) }.play

// modulate formant frequency, fundamental freq stays constant
{ Formant.ar(200, XLine.kr(400, 4000, 8), 200, 0.125) }.play

// modulate width frequency, other freqs stay constant
{ Formant.ar(400, 2000, XLine.kr(800, 8000, 8), 0.125) }.play

// Impulse

{ Impulse.ar(800, 0.0, 0.5, 0) }.play;

{ Impulse.ar(XLine.kr(800,100,5), 0.0,  0.5, 0) }.play;

{ Impulse.ar(4, [0, MouseX.kr(0, 1)], 0.2) }.play;

SynthDef(\imp, { OffsetOut.ar(0, Impulse.ar(0)); FreeSelf.kr(Impulse.kr(0)); }).add;
fork { (1 / (1..60).scramble).do { |dt| Synth.grain(\imp);  dt.wait } };


// LFPulse und Scope
{ LFPulse.ar(500, 0, MouseX.kr, 0.5) }.scope;


(
{
    [
        Pulse.ar(100, 0.3, 0.5),
        LFPulse.ar(100, 0, 0.3, 0.5)
    ] * 0.2
}.scope(bufsize: 44100, zoom: 5)

)

/// SinOscFB

{SinOscFB.ar(440,MouseX.kr(0,4))*0.1}.play

{SinOscFB.ar(MouseY.kr(10,1000,'exponential'),MouseX.kr(0.5pi,pi))*0.1}.play

{SinOscFB.ar(100*SinOscFB.ar(MouseY.kr(1,1000,'exponential'))+200,MouseX.kr(0.5pi,pi))*0.1}.play

// Scope the wave form
{ SinOscFB.ar([400,301], MouseX.kr(0,4),0.3); }.scope;




