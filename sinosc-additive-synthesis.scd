(
{
var freq = 220, o1=0, o2=0, o3=0, o4=0, o5=0,
	num = 5;

	o1=0; o2=0; o3=0; o4=0; o5=0;

	if (num > 0,
		{o1 = SinOsc.ar(freq * 1, 0, 1.0 / 1.0);}
	);
	if (num > 1,
		{o2 = SinOsc.ar(freq * 2, 0, 1.0 / 2.0);}
	);
	if (num > 2,
		{o3 = SinOsc.ar(freq * 3, 0, 1.0 / 3.0);}
	);
	if (num > 3,
		{o4 = SinOsc.ar(freq * 4, 0, 1.0 / 4.0);}
	);
	if (num > 4,
		{o5 = SinOsc.ar(freq * 5, 0, 1.0 / 5.0);}
	);

	Out.ar([0,1], (o1+o2+o3+o4+o5)/(num+1));

}.scope
)


// variant with a buffer
(
b = Buffer.alloc(s, 512, 1);
b.sine1(1.0 / [1, 2, 3, 4, 5], true, true, true);

x = { Osc.ar(b, 500, 0, 0.5) }.scope;
)

// another variant with a buffer
(
b = Buffer.alloc(s, 512, 1,
	{
		arg buf;
		buf.sine1Msg(1.0/[1,2,3,4,5,6,7,8,9,10,11])
}
);

{ BufRd.ar(
	1, b,
	Phasor.ar(0,
		BufRateScale.kr(b),
		0, BufFrames.kr(b)))
}.scope;
)


// a simple SynthDef
(
SynthDef(\simple, {
    Out.ar(0,
        LFTri.ar(Rand(400, 800), 0, 0.1)
		* Line.kr(1, 0, 0.9, doneAction: 2)
    )
}).add;
)

a = Synth(\simple);

