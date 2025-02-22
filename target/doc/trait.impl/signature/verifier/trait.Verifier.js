(function() {var implementors = {
"ecdsa":[["impl&lt;C&gt; <a class=\"trait\" href=\"signature/verifier/trait.Verifier.html\" title=\"trait signature::verifier::Verifier\">Verifier</a>&lt;<a class=\"struct\" href=\"ecdsa/der/struct.Signature.html\" title=\"struct ecdsa::der::Signature\">Signature</a>&lt;C&gt;&gt; for <a class=\"struct\" href=\"ecdsa/struct.VerifyingKey.html\" title=\"struct ecdsa::VerifyingKey\">VerifyingKey</a>&lt;C&gt;<div class=\"where\">where\n    C: <a class=\"trait\" href=\"ecdsa/trait.PrimeCurve.html\" title=\"trait ecdsa::PrimeCurve\">PrimeCurve</a> + <a class=\"trait\" href=\"elliptic_curve/arithmetic/trait.CurveArithmetic.html\" title=\"trait elliptic_curve::arithmetic::CurveArithmetic\">CurveArithmetic</a> + <a class=\"trait\" href=\"ecdsa/hazmat/trait.DigestPrimitive.html\" title=\"trait ecdsa::hazmat::DigestPrimitive\">DigestPrimitive</a>,\n    <a class=\"type\" href=\"elliptic_curve/point/type.AffinePoint.html\" title=\"type elliptic_curve::point::AffinePoint\">AffinePoint</a>&lt;C&gt;: <a class=\"trait\" href=\"ecdsa/hazmat/trait.VerifyPrimitive.html\" title=\"trait ecdsa::hazmat::VerifyPrimitive\">VerifyPrimitive</a>&lt;C&gt;,\n    <a class=\"type\" href=\"ecdsa/type.SignatureSize.html\" title=\"type ecdsa::SignatureSize\">SignatureSize</a>&lt;C&gt;: <a class=\"trait\" href=\"generic_array/trait.ArrayLength.html\" title=\"trait generic_array::ArrayLength\">ArrayLength</a>&lt;<a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.u8.html\">u8</a>&gt;,\n    <a class=\"type\" href=\"ecdsa/der/type.MaxSize.html\" title=\"type ecdsa::der::MaxSize\">MaxSize</a>&lt;C&gt;: <a class=\"trait\" href=\"generic_array/trait.ArrayLength.html\" title=\"trait generic_array::ArrayLength\">ArrayLength</a>&lt;<a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.u8.html\">u8</a>&gt;,\n    &lt;<a class=\"type\" href=\"elliptic_curve/field/type.FieldBytesSize.html\" title=\"type elliptic_curve::field::FieldBytesSize\">FieldBytesSize</a>&lt;C&gt; as <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/ops/arith/trait.Add.html\" title=\"trait core::ops::arith::Add\">Add</a>&gt;::<a class=\"associatedtype\" href=\"https://doc.rust-lang.org/nightly/core/ops/arith/trait.Add.html#associatedtype.Output\" title=\"type core::ops::arith::Add::Output\">Output</a>: <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/ops/arith/trait.Add.html\" title=\"trait core::ops::arith::Add\">Add</a>&lt;<a class=\"type\" href=\"ecdsa/der/type.MaxOverhead.html\" title=\"type ecdsa::der::MaxOverhead\">MaxOverhead</a>&gt; + <a class=\"trait\" href=\"generic_array/trait.ArrayLength.html\" title=\"trait generic_array::ArrayLength\">ArrayLength</a>&lt;<a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.u8.html\">u8</a>&gt;,</div>"],["impl&lt;C&gt; <a class=\"trait\" href=\"signature/verifier/trait.Verifier.html\" title=\"trait signature::verifier::Verifier\">Verifier</a>&lt;<a class=\"struct\" href=\"ecdsa/struct.Signature.html\" title=\"struct ecdsa::Signature\">Signature</a>&lt;C&gt;&gt; for <a class=\"struct\" href=\"ecdsa/struct.VerifyingKey.html\" title=\"struct ecdsa::VerifyingKey\">VerifyingKey</a>&lt;C&gt;<div class=\"where\">where\n    C: <a class=\"trait\" href=\"ecdsa/trait.PrimeCurve.html\" title=\"trait ecdsa::PrimeCurve\">PrimeCurve</a> + <a class=\"trait\" href=\"elliptic_curve/arithmetic/trait.CurveArithmetic.html\" title=\"trait elliptic_curve::arithmetic::CurveArithmetic\">CurveArithmetic</a> + <a class=\"trait\" href=\"ecdsa/hazmat/trait.DigestPrimitive.html\" title=\"trait ecdsa::hazmat::DigestPrimitive\">DigestPrimitive</a>,\n    <a class=\"type\" href=\"elliptic_curve/point/type.AffinePoint.html\" title=\"type elliptic_curve::point::AffinePoint\">AffinePoint</a>&lt;C&gt;: <a class=\"trait\" href=\"ecdsa/hazmat/trait.VerifyPrimitive.html\" title=\"trait ecdsa::hazmat::VerifyPrimitive\">VerifyPrimitive</a>&lt;C&gt;,\n    <a class=\"type\" href=\"ecdsa/type.SignatureSize.html\" title=\"type ecdsa::SignatureSize\">SignatureSize</a>&lt;C&gt;: <a class=\"trait\" href=\"generic_array/trait.ArrayLength.html\" title=\"trait generic_array::ArrayLength\">ArrayLength</a>&lt;<a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.u8.html\">u8</a>&gt;,</div>"]],
"ed25519_dalek":[["impl <a class=\"trait\" href=\"ed25519_dalek/trait.Verifier.html\" title=\"trait ed25519_dalek::Verifier\">Verifier</a>&lt;<a class=\"struct\" href=\"ed25519_dalek/struct.Signature.html\" title=\"struct ed25519_dalek::Signature\">Signature</a>&gt; for <a class=\"struct\" href=\"ed25519_dalek/struct.PublicKey.html\" title=\"struct ed25519_dalek::PublicKey\">PublicKey</a>"],["impl <a class=\"trait\" href=\"ed25519_dalek/trait.Verifier.html\" title=\"trait ed25519_dalek::Verifier\">Verifier</a>&lt;<a class=\"struct\" href=\"ed25519_dalek/struct.Signature.html\" title=\"struct ed25519_dalek::Signature\">Signature</a>&gt; for <a class=\"struct\" href=\"ed25519_dalek/struct.Keypair.html\" title=\"struct ed25519_dalek::Keypair\">Keypair</a>"]]
};if (window.register_implementors) {window.register_implementors(implementors);} else {window.pending_implementors = implementors;}})()