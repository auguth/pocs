(function() {var type_impls = {
"spki":[["<details class=\"toggle implementors-toggle\" open><summary><section id=\"impl-Clone-for-SubjectPublicKeyInfo%3CParams,+Key%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/spki/spki.rs.html#43\">source</a><a href=\"#impl-Clone-for-SubjectPublicKeyInfo%3CParams,+Key%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;Params: <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/clone/trait.Clone.html\" title=\"trait core::clone::Clone\">Clone</a>, Key: <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/clone/trait.Clone.html\" title=\"trait core::clone::Clone\">Clone</a>&gt; <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/clone/trait.Clone.html\" title=\"trait core::clone::Clone\">Clone</a> for <a class=\"struct\" href=\"spki/struct.SubjectPublicKeyInfo.html\" title=\"struct spki::SubjectPublicKeyInfo\">SubjectPublicKeyInfo</a>&lt;Params, Key&gt;</h3></section></summary><div class=\"impl-items\"><details class=\"toggle method-toggle\" open><summary><section id=\"method.clone\" class=\"method trait-impl\"><a class=\"src rightside\" href=\"src/spki/spki.rs.html#43\">source</a><a href=\"#method.clone\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"https://doc.rust-lang.org/nightly/core/clone/trait.Clone.html#tymethod.clone\" class=\"fn\">clone</a>(&amp;self) -&gt; <a class=\"struct\" href=\"spki/struct.SubjectPublicKeyInfo.html\" title=\"struct spki::SubjectPublicKeyInfo\">SubjectPublicKeyInfo</a>&lt;Params, Key&gt;</h4></section></summary><div class='docblock'>Returns a copy of the value. <a href=\"https://doc.rust-lang.org/nightly/core/clone/trait.Clone.html#tymethod.clone\">Read more</a></div></details><details class=\"toggle method-toggle\" open><summary><section id=\"method.clone_from\" class=\"method trait-impl\"><span class=\"rightside\"><span class=\"since\" title=\"Stable since Rust version 1.0.0\">1.0.0</span> · <a class=\"src\" href=\"https://doc.rust-lang.org/nightly/src/core/clone.rs.html#169\">source</a></span><a href=\"#method.clone_from\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"https://doc.rust-lang.org/nightly/core/clone/trait.Clone.html#method.clone_from\" class=\"fn\">clone_from</a>(&amp;mut self, source: <a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.reference.html\">&amp;Self</a>)</h4></section></summary><div class='docblock'>Performs copy-assignment from <code>source</code>. <a href=\"https://doc.rust-lang.org/nightly/core/clone/trait.Clone.html#method.clone_from\">Read more</a></div></details></div></details>","Clone","spki::spki::SubjectPublicKeyInfoRef","spki::spki::SubjectPublicKeyInfoOwned"],["<details class=\"toggle implementors-toggle\" open><summary><section id=\"impl-Debug-for-SubjectPublicKeyInfo%3CParams,+Key%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/spki/spki.rs.html#43\">source</a><a href=\"#impl-Debug-for-SubjectPublicKeyInfo%3CParams,+Key%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;Params: <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/fmt/trait.Debug.html\" title=\"trait core::fmt::Debug\">Debug</a>, Key: <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/fmt/trait.Debug.html\" title=\"trait core::fmt::Debug\">Debug</a>&gt; <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/fmt/trait.Debug.html\" title=\"trait core::fmt::Debug\">Debug</a> for <a class=\"struct\" href=\"spki/struct.SubjectPublicKeyInfo.html\" title=\"struct spki::SubjectPublicKeyInfo\">SubjectPublicKeyInfo</a>&lt;Params, Key&gt;</h3></section></summary><div class=\"impl-items\"><details class=\"toggle method-toggle\" open><summary><section id=\"method.fmt\" class=\"method trait-impl\"><a class=\"src rightside\" href=\"src/spki/spki.rs.html#43\">source</a><a href=\"#method.fmt\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"https://doc.rust-lang.org/nightly/core/fmt/trait.Debug.html#tymethod.fmt\" class=\"fn\">fmt</a>(&amp;self, f: &amp;mut <a class=\"struct\" href=\"https://doc.rust-lang.org/nightly/core/fmt/struct.Formatter.html\" title=\"struct core::fmt::Formatter\">Formatter</a>&lt;'_&gt;) -&gt; <a class=\"type\" href=\"https://doc.rust-lang.org/nightly/core/fmt/type.Result.html\" title=\"type core::fmt::Result\">Result</a></h4></section></summary><div class='docblock'>Formats the value using the given formatter. <a href=\"https://doc.rust-lang.org/nightly/core/fmt/trait.Debug.html#tymethod.fmt\">Read more</a></div></details></div></details>","Debug","spki::spki::SubjectPublicKeyInfoRef","spki::spki::SubjectPublicKeyInfoOwned"],["<details class=\"toggle implementors-toggle\" open><summary><section id=\"impl-TryFrom%3C%26%5Bu8%5D%3E-for-SubjectPublicKeyInfo%3CParams,+Key%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/spki/spki.rs.html#123-133\">source</a><a href=\"#impl-TryFrom%3C%26%5Bu8%5D%3E-for-SubjectPublicKeyInfo%3CParams,+Key%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;'a, Params, Key&gt; <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/convert/trait.TryFrom.html\" title=\"trait core::convert::TryFrom\">TryFrom</a>&lt;&amp;'a [<a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.u8.html\">u8</a>]&gt; for <a class=\"struct\" href=\"spki/struct.SubjectPublicKeyInfo.html\" title=\"struct spki::SubjectPublicKeyInfo\">SubjectPublicKeyInfo</a>&lt;Params, Key&gt;<div class=\"where\">where\n    Params: <a class=\"trait\" href=\"der/asn1/choice/trait.Choice.html\" title=\"trait der::asn1::choice::Choice\">Choice</a>&lt;'a&gt; + <a class=\"trait\" href=\"der/encode/trait.Encode.html\" title=\"trait der::encode::Encode\">Encode</a>,\n    Key: <a class=\"trait\" href=\"der/decode/trait.Decode.html\" title=\"trait der::decode::Decode\">Decode</a>&lt;'a&gt; + <a class=\"trait\" href=\"der/encode/trait.Encode.html\" title=\"trait der::encode::Encode\">Encode</a> + <a class=\"trait\" href=\"der/tag/trait.FixedTag.html\" title=\"trait der::tag::FixedTag\">FixedTag</a>,</div></h3></section></summary><div class=\"impl-items\"><details class=\"toggle\" open><summary><section id=\"associatedtype.Error\" class=\"associatedtype trait-impl\"><a href=\"#associatedtype.Error\" class=\"anchor\">§</a><h4 class=\"code-header\">type <a href=\"https://doc.rust-lang.org/nightly/core/convert/trait.TryFrom.html#associatedtype.Error\" class=\"associatedtype\">Error</a> = <a class=\"enum\" href=\"spki/enum.Error.html\" title=\"enum spki::Error\">Error</a></h4></section></summary><div class='docblock'>The type returned in the event of a conversion error.</div></details><details class=\"toggle method-toggle\" open><summary><section id=\"method.try_from\" class=\"method trait-impl\"><a class=\"src rightside\" href=\"src/spki/spki.rs.html#130-132\">source</a><a href=\"#method.try_from\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"https://doc.rust-lang.org/nightly/core/convert/trait.TryFrom.html#tymethod.try_from\" class=\"fn\">try_from</a>(bytes: &amp;'a [<a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.u8.html\">u8</a>]) -&gt; <a class=\"type\" href=\"spki/type.Result.html\" title=\"type spki::Result\">Result</a>&lt;Self&gt;</h4></section></summary><div class='docblock'>Performs the conversion.</div></details></div></details>","TryFrom<&'a [u8]>","spki::spki::SubjectPublicKeyInfoRef","spki::spki::SubjectPublicKeyInfoOwned"],["<details class=\"toggle implementors-toggle\" open><summary><section id=\"impl-EncodeValue-for-SubjectPublicKeyInfo%3CParams,+Key%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/spki/spki.rs.html#100-114\">source</a><a href=\"#impl-EncodeValue-for-SubjectPublicKeyInfo%3CParams,+Key%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;'a, Params, Key&gt; <a class=\"trait\" href=\"der/encode/trait.EncodeValue.html\" title=\"trait der::encode::EncodeValue\">EncodeValue</a> for <a class=\"struct\" href=\"spki/struct.SubjectPublicKeyInfo.html\" title=\"struct spki::SubjectPublicKeyInfo\">SubjectPublicKeyInfo</a>&lt;Params, Key&gt;<div class=\"where\">where\n    Params: <a class=\"trait\" href=\"der/asn1/choice/trait.Choice.html\" title=\"trait der::asn1::choice::Choice\">Choice</a>&lt;'a&gt; + <a class=\"trait\" href=\"der/encode/trait.Encode.html\" title=\"trait der::encode::Encode\">Encode</a>,\n    Key: <a class=\"trait\" href=\"der/encode/trait.Encode.html\" title=\"trait der::encode::Encode\">Encode</a>,</div></h3></section></summary><div class=\"impl-items\"><details class=\"toggle method-toggle\" open><summary><section id=\"method.value_len\" class=\"method trait-impl\"><a class=\"src rightside\" href=\"src/spki/spki.rs.html#105-107\">source</a><a href=\"#method.value_len\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"der/encode/trait.EncodeValue.html#tymethod.value_len\" class=\"fn\">value_len</a>(&amp;self) -&gt; <a class=\"type\" href=\"der/error/type.Result.html\" title=\"type der::error::Result\">Result</a>&lt;<a class=\"struct\" href=\"der/length/struct.Length.html\" title=\"struct der::length::Length\">Length</a>&gt;</h4></section></summary><div class='docblock'>Compute the length of this value (sans [<code>Tag</code>]+<a href=\"der/length/struct.Length.html\" title=\"struct der::length::Length\"><code>Length</code></a> header) when\nencoded as ASN.1 DER.</div></details><details class=\"toggle method-toggle\" open><summary><section id=\"method.encode_value\" class=\"method trait-impl\"><a class=\"src rightside\" href=\"src/spki/spki.rs.html#109-113\">source</a><a href=\"#method.encode_value\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"der/encode/trait.EncodeValue.html#tymethod.encode_value\" class=\"fn\">encode_value</a>(&amp;self, writer: &amp;mut impl <a class=\"trait\" href=\"der/writer/trait.Writer.html\" title=\"trait der::writer::Writer\">Writer</a>) -&gt; <a class=\"type\" href=\"der/error/type.Result.html\" title=\"type der::error::Result\">Result</a>&lt;<a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.unit.html\">()</a>&gt;</h4></section></summary><div class='docblock'>Encode value (sans [<code>Tag</code>]+<a href=\"der/length/struct.Length.html\" title=\"struct der::length::Length\"><code>Length</code></a> header) as ASN.1 DER using the\nprovided <a href=\"der/writer/trait.Writer.html\" title=\"trait der::writer::Writer\"><code>Writer</code></a>.</div></details></div></details>","EncodeValue","spki::spki::SubjectPublicKeyInfoRef","spki::spki::SubjectPublicKeyInfoOwned"],["<section id=\"impl-Eq-for-SubjectPublicKeyInfo%3CParams,+Key%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/spki/spki.rs.html#43\">source</a><a href=\"#impl-Eq-for-SubjectPublicKeyInfo%3CParams,+Key%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;Params: <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/cmp/trait.Eq.html\" title=\"trait core::cmp::Eq\">Eq</a>, Key: <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/cmp/trait.Eq.html\" title=\"trait core::cmp::Eq\">Eq</a>&gt; <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/cmp/trait.Eq.html\" title=\"trait core::cmp::Eq\">Eq</a> for <a class=\"struct\" href=\"spki/struct.SubjectPublicKeyInfo.html\" title=\"struct spki::SubjectPublicKeyInfo\">SubjectPublicKeyInfo</a>&lt;Params, Key&gt;</h3></section>","Eq","spki::spki::SubjectPublicKeyInfoRef","spki::spki::SubjectPublicKeyInfoOwned"],["<section id=\"impl-StructuralEq-for-SubjectPublicKeyInfo%3CParams,+Key%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/spki/spki.rs.html#43\">source</a><a href=\"#impl-StructuralEq-for-SubjectPublicKeyInfo%3CParams,+Key%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;Params, Key&gt; <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/marker/trait.StructuralEq.html\" title=\"trait core::marker::StructuralEq\">StructuralEq</a> for <a class=\"struct\" href=\"spki/struct.SubjectPublicKeyInfo.html\" title=\"struct spki::SubjectPublicKeyInfo\">SubjectPublicKeyInfo</a>&lt;Params, Key&gt;</h3></section>","StructuralEq","spki::spki::SubjectPublicKeyInfoRef","spki::spki::SubjectPublicKeyInfoOwned"],["<details class=\"toggle implementors-toggle\" open><summary><section id=\"impl-PartialEq-for-SubjectPublicKeyInfo%3CParams,+Key%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/spki/spki.rs.html#43\">source</a><a href=\"#impl-PartialEq-for-SubjectPublicKeyInfo%3CParams,+Key%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;Params: <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/cmp/trait.PartialEq.html\" title=\"trait core::cmp::PartialEq\">PartialEq</a>, Key: <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/cmp/trait.PartialEq.html\" title=\"trait core::cmp::PartialEq\">PartialEq</a>&gt; <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/cmp/trait.PartialEq.html\" title=\"trait core::cmp::PartialEq\">PartialEq</a> for <a class=\"struct\" href=\"spki/struct.SubjectPublicKeyInfo.html\" title=\"struct spki::SubjectPublicKeyInfo\">SubjectPublicKeyInfo</a>&lt;Params, Key&gt;</h3></section></summary><div class=\"impl-items\"><details class=\"toggle method-toggle\" open><summary><section id=\"method.eq\" class=\"method trait-impl\"><a class=\"src rightside\" href=\"src/spki/spki.rs.html#43\">source</a><a href=\"#method.eq\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"https://doc.rust-lang.org/nightly/core/cmp/trait.PartialEq.html#tymethod.eq\" class=\"fn\">eq</a>(&amp;self, other: &amp;<a class=\"struct\" href=\"spki/struct.SubjectPublicKeyInfo.html\" title=\"struct spki::SubjectPublicKeyInfo\">SubjectPublicKeyInfo</a>&lt;Params, Key&gt;) -&gt; <a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.bool.html\">bool</a></h4></section></summary><div class='docblock'>This method tests for <code>self</code> and <code>other</code> values to be equal, and is used\nby <code>==</code>.</div></details><details class=\"toggle method-toggle\" open><summary><section id=\"method.ne\" class=\"method trait-impl\"><span class=\"rightside\"><span class=\"since\" title=\"Stable since Rust version 1.0.0\">1.0.0</span> · <a class=\"src\" href=\"https://doc.rust-lang.org/nightly/src/core/cmp.rs.html#242\">source</a></span><a href=\"#method.ne\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"https://doc.rust-lang.org/nightly/core/cmp/trait.PartialEq.html#method.ne\" class=\"fn\">ne</a>(&amp;self, other: <a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.reference.html\">&amp;Rhs</a>) -&gt; <a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.bool.html\">bool</a></h4></section></summary><div class='docblock'>This method tests for <code>!=</code>. The default implementation is almost always\nsufficient, and should not be overridden without very good reason.</div></details></div></details>","PartialEq","spki::spki::SubjectPublicKeyInfoRef","spki::spki::SubjectPublicKeyInfoOwned"],["<details class=\"toggle implementors-toggle\" open><summary><section id=\"impl-DecodeValue%3C'a%3E-for-SubjectPublicKeyInfo%3CParams,+Key%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/spki/spki.rs.html#85-98\">source</a><a href=\"#impl-DecodeValue%3C'a%3E-for-SubjectPublicKeyInfo%3CParams,+Key%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;'a: 'k, 'k, Params, Key&gt; <a class=\"trait\" href=\"der/decode/trait.DecodeValue.html\" title=\"trait der::decode::DecodeValue\">DecodeValue</a>&lt;'a&gt; for <a class=\"struct\" href=\"spki/struct.SubjectPublicKeyInfo.html\" title=\"struct spki::SubjectPublicKeyInfo\">SubjectPublicKeyInfo</a>&lt;Params, Key&gt;<div class=\"where\">where\n    Params: <a class=\"trait\" href=\"der/asn1/choice/trait.Choice.html\" title=\"trait der::asn1::choice::Choice\">Choice</a>&lt;'a&gt; + <a class=\"trait\" href=\"der/encode/trait.Encode.html\" title=\"trait der::encode::Encode\">Encode</a>,\n    Key: <a class=\"trait\" href=\"der/decode/trait.Decode.html\" title=\"trait der::decode::Decode\">Decode</a>&lt;'a&gt; + 'k,</div></h3></section></summary><div class=\"impl-items\"><details class=\"toggle method-toggle\" open><summary><section id=\"method.decode_value\" class=\"method trait-impl\"><a class=\"src rightside\" href=\"src/spki/spki.rs.html#90-97\">source</a><a href=\"#method.decode_value\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"der/decode/trait.DecodeValue.html#tymethod.decode_value\" class=\"fn\">decode_value</a>&lt;R: <a class=\"trait\" href=\"der/reader/trait.Reader.html\" title=\"trait der::reader::Reader\">Reader</a>&lt;'a&gt;&gt;(reader: <a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.reference.html\">&amp;mut R</a>, header: <a class=\"struct\" href=\"der/header/struct.Header.html\" title=\"struct der::header::Header\">Header</a>) -&gt; <a class=\"type\" href=\"der/error/type.Result.html\" title=\"type der::error::Result\">Result</a>&lt;Self&gt;</h4></section></summary><div class='docblock'>Attempt to decode this message using the provided <a href=\"der/reader/trait.Reader.html\" title=\"trait der::reader::Reader\"><code>Reader</code></a>.</div></details></div></details>","DecodeValue<'a>","spki::spki::SubjectPublicKeyInfoRef","spki::spki::SubjectPublicKeyInfoOwned"],["<section id=\"impl-Sequence%3C'a%3E-for-SubjectPublicKeyInfo%3CParams,+Key%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/spki/spki.rs.html#116-121\">source</a><a href=\"#impl-Sequence%3C'a%3E-for-SubjectPublicKeyInfo%3CParams,+Key%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;'a, Params, Key&gt; <a class=\"trait\" href=\"der/asn1/sequence/trait.Sequence.html\" title=\"trait der::asn1::sequence::Sequence\">Sequence</a>&lt;'a&gt; for <a class=\"struct\" href=\"spki/struct.SubjectPublicKeyInfo.html\" title=\"struct spki::SubjectPublicKeyInfo\">SubjectPublicKeyInfo</a>&lt;Params, Key&gt;<div class=\"where\">where\n    Params: <a class=\"trait\" href=\"der/asn1/choice/trait.Choice.html\" title=\"trait der::asn1::choice::Choice\">Choice</a>&lt;'a&gt; + <a class=\"trait\" href=\"der/encode/trait.Encode.html\" title=\"trait der::encode::Encode\">Encode</a>,\n    Key: <a class=\"trait\" href=\"der/decode/trait.Decode.html\" title=\"trait der::decode::Decode\">Decode</a>&lt;'a&gt; + <a class=\"trait\" href=\"der/encode/trait.Encode.html\" title=\"trait der::encode::Encode\">Encode</a> + <a class=\"trait\" href=\"der/tag/trait.FixedTag.html\" title=\"trait der::tag::FixedTag\">FixedTag</a>,</div></h3></section>","Sequence<'a>","spki::spki::SubjectPublicKeyInfoRef","spki::spki::SubjectPublicKeyInfoOwned"],["<details class=\"toggle implementors-toggle\" open><summary><section id=\"impl-ValueOrd-for-SubjectPublicKeyInfo%3CParams,+Key%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/spki/spki.rs.html#135-146\">source</a><a href=\"#impl-ValueOrd-for-SubjectPublicKeyInfo%3CParams,+Key%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;'a, Params, Key&gt; <a class=\"trait\" href=\"der/ord/trait.ValueOrd.html\" title=\"trait der::ord::ValueOrd\">ValueOrd</a> for <a class=\"struct\" href=\"spki/struct.SubjectPublicKeyInfo.html\" title=\"struct spki::SubjectPublicKeyInfo\">SubjectPublicKeyInfo</a>&lt;Params, Key&gt;<div class=\"where\">where\n    Params: <a class=\"trait\" href=\"der/asn1/choice/trait.Choice.html\" title=\"trait der::asn1::choice::Choice\">Choice</a>&lt;'a&gt; + <a class=\"trait\" href=\"der/ord/trait.DerOrd.html\" title=\"trait der::ord::DerOrd\">DerOrd</a> + <a class=\"trait\" href=\"der/encode/trait.Encode.html\" title=\"trait der::encode::Encode\">Encode</a>,\n    Key: <a class=\"trait\" href=\"der/ord/trait.ValueOrd.html\" title=\"trait der::ord::ValueOrd\">ValueOrd</a>,</div></h3></section></summary><div class=\"impl-items\"><details class=\"toggle method-toggle\" open><summary><section id=\"method.value_cmp\" class=\"method trait-impl\"><a class=\"src rightside\" href=\"src/spki/spki.rs.html#140-145\">source</a><a href=\"#method.value_cmp\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"der/ord/trait.ValueOrd.html#tymethod.value_cmp\" class=\"fn\">value_cmp</a>(&amp;self, other: <a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.reference.html\">&amp;Self</a>) -&gt; <a class=\"type\" href=\"der/error/type.Result.html\" title=\"type der::error::Result\">Result</a>&lt;<a class=\"enum\" href=\"https://doc.rust-lang.org/nightly/core/cmp/enum.Ordering.html\" title=\"enum core::cmp::Ordering\">Ordering</a>&gt;</h4></section></summary><div class='docblock'>Return an <a href=\"https://doc.rust-lang.org/nightly/core/cmp/enum.Ordering.html\" title=\"enum core::cmp::Ordering\"><code>Ordering</code></a> between value portion of TLV-encoded <code>self</code> and\n<code>other</code> when serialized as ASN.1 DER.</div></details></div></details>","ValueOrd","spki::spki::SubjectPublicKeyInfoRef","spki::spki::SubjectPublicKeyInfoOwned"],["<section id=\"impl-StructuralPartialEq-for-SubjectPublicKeyInfo%3CParams,+Key%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/spki/spki.rs.html#43\">source</a><a href=\"#impl-StructuralPartialEq-for-SubjectPublicKeyInfo%3CParams,+Key%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;Params, Key&gt; <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/marker/trait.StructuralPartialEq.html\" title=\"trait core::marker::StructuralPartialEq\">StructuralPartialEq</a> for <a class=\"struct\" href=\"spki/struct.SubjectPublicKeyInfo.html\" title=\"struct spki::SubjectPublicKeyInfo\">SubjectPublicKeyInfo</a>&lt;Params, Key&gt;</h3></section>","StructuralPartialEq","spki::spki::SubjectPublicKeyInfoRef","spki::spki::SubjectPublicKeyInfoOwned"]]
};if (window.register_type_impls) {window.register_type_impls(type_impls);} else {window.pending_type_impls = type_impls;}})()