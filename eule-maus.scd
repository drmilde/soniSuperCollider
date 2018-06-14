p = ProxySpace.push(s.boot);

~out.play(0,2);

// taube eule und maus
(
~out = {
	var tr, e, eg, fm, maus;
	maus = MouseX.kr(0.1, 2);
	e =  Env([0, 1, 0.4, 1, 0], [0.03, 0.2 * maus, 0.2, maus]);
	tr = Dust.kr(0.3);
	eg = EnvGen.kr(e, tr);
	fm = SinOsc.ar(30, 0, 0.2 * (1 - eg), 1);
	SinOsc.ar(100 * eg + 200 * fm) * 0.1 * eg
};
)

// taube eulen und maus
(
~out = {
	var tr, e, eg, fm, maus;
	maus = MouseX.kr(0.1, 2);
	e =   { Env([0, 1, 0.4, 1, 0], [0.03, 0.2.rand, 0.2, maus]) };
	tr = { Dust.kr(0.3) };
	eg = [
			EnvGen.kr(e.value, tr.value),
			EnvGen.kr(e.value, tr.value)
	];
	fm = SinOsc.ar(30, 0, 0.2 * (1 - eg), 1);
	SinOsc.ar(100 * eg + 200 * [1, 1.15] * fm) * 0.1 * eg
};
)


// eulenschlag und maus
(
~out = {
	var tr, e, eg, fm, maus, n, u;
	n = 6;
	maus = MouseX.kr(0.1, 2);
	e =   { Env([0, 1, 0.4, 1, 0], [0.03, 0.2.rand, 0.2, maus]) };
	tr = { Dust.kr(0.1) };
	eg =  (e ! n).collect { arg env; EnvGen.kr(env, tr.value) };
	fm = SinOsc.ar({ 30 + 2.0.rand2 } ! n, 0, 0.2 * (1 - eg), 1);
	u = SinOsc.ar(100 * eg + 200 * { rrand(0.9, 1.1) } ! n * fm) * 0.1 * eg;
	u.clump(2).sum
};
)

/*
authors so far:
jrh
*/