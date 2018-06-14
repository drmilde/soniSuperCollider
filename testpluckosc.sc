(
s.waitForBoot({
    SynthDef(\pluck,{arg freq=55;
        Out.ar(0,
        Pluck.ar(WhiteNoise.ar(0.06),
            EnvGen.kr(Env.perc(0,4), 1.0, doneAction: 2),
            freq.reciprocal,
            freq.reciprocal,
            10,
        coef:0.1)!2
        );
    }).add;


    w = Window.new("Hold arrow keys to trigger sound",Rect(300,Window.screenBounds.height-300,400,100)).front;
    a = Slider(w, Rect(50, 20, 300, 40))
        .value_(0.5)
        .step_(0.05)
        .focus
        .action_({
            // trigger a synth with varying frequencies
            Synth(\pluck, [\freq,55+(1100*a.value)]);
            w.view.background_(Gradient(Color.rand,Color.rand));
        })
});


n = NetAddr("127.0.0.1", NetAddr.langPort);
o = OSCFunc.newMatching({ arg msg, time, addr, recvPort; Synth(\pluck, [\freq,55+(1100*msg[1].value)]); msg[1].postln;}, '/goodbye');

)


200/400

1.2.value
