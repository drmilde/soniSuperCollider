// you have to write the sample path in the firts line

~bufferdue = Buffer.read(s,"/Users/audio_a_01/Desktop/system1/SuperCollider/code/GrandPiano/v8/036-C3v8.wav", bufnum:2);



(
SynthDef.new(\bufbeat, {
	arg amp = 1, out = 0, buf, start, end, freq = 1;
	var sig, ptr;
	ptr = LFNoise1.ar(freq).range(0.0,end);
	sig = BufRd.ar(2, buf, ptr);
	sig = sig * amp;
	Out.ar(out, sig);
}).add
)

(
x = Synth.new(\bufbeat,
	[\buf, ~bufferdue.bufnum, \start,0, \end, ~bufferdue.numFrames-1, \freq, 4, \amp, 0.5], g);
)
x.free;
