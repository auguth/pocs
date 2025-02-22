(function() {var type_impls = {
"sp_runtime_interface":[["<details class=\"toggle implementors-toggle\" open><summary><section id=\"impl-Pointer%3CT%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/sp_wasm_interface/lib.rs.html#161\">source</a><a href=\"#impl-Pointer%3CT%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;T&gt; <a class=\"struct\" href=\"sp_wasm_interface/struct.Pointer.html\" title=\"struct sp_wasm_interface::Pointer\">Pointer</a>&lt;T&gt;<div class=\"where\">where\n    T: <a class=\"trait\" href=\"sp_wasm_interface/trait.PointerType.html\" title=\"trait sp_wasm_interface::PointerType\">PointerType</a>,</div></h3></section></summary><div class=\"impl-items\"><details class=\"toggle method-toggle\" open><summary><section id=\"method.new\" class=\"method\"><a class=\"src rightside\" href=\"src/sp_wasm_interface/lib.rs.html#163\">source</a><h4 class=\"code-header\">pub fn <a href=\"sp_wasm_interface/struct.Pointer.html#tymethod.new\" class=\"fn\">new</a>(ptr: <a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.u32.html\">u32</a>) -&gt; <a class=\"struct\" href=\"sp_wasm_interface/struct.Pointer.html\" title=\"struct sp_wasm_interface::Pointer\">Pointer</a>&lt;T&gt;</h4></section></summary><div class=\"docblock\"><p>Create a new instance of <code>Self</code>.</p>\n</div></details><details class=\"toggle method-toggle\" open><summary><section id=\"method.offset\" class=\"method\"><a class=\"src rightside\" href=\"src/sp_wasm_interface/lib.rs.html#173\">source</a><h4 class=\"code-header\">pub fn <a href=\"sp_wasm_interface/struct.Pointer.html#tymethod.offset\" class=\"fn\">offset</a>(self, offset: <a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.u32.html\">u32</a>) -&gt; <a class=\"enum\" href=\"https://doc.rust-lang.org/nightly/core/option/enum.Option.html\" title=\"enum core::option::Option\">Option</a>&lt;<a class=\"struct\" href=\"sp_wasm_interface/struct.Pointer.html\" title=\"struct sp_wasm_interface::Pointer\">Pointer</a>&lt;T&gt;&gt;</h4></section></summary><div class=\"docblock\"><p>Calculate the offset from this pointer.</p>\n<p><code>offset</code> is in units of <code>T</code>. So, <code>3</code> means <code>3 * mem::size_of::&lt;T&gt;()</code> as offset to the\npointer.</p>\n<p>Returns an <code>Option</code> to respect that the pointer could probably overflow.</p>\n</div></details><details class=\"toggle method-toggle\" open><summary><section id=\"method.null\" class=\"method\"><a class=\"src rightside\" href=\"src/sp_wasm_interface/lib.rs.html#181\">source</a><h4 class=\"code-header\">pub fn <a href=\"sp_wasm_interface/struct.Pointer.html#tymethod.null\" class=\"fn\">null</a>() -&gt; <a class=\"struct\" href=\"sp_wasm_interface/struct.Pointer.html\" title=\"struct sp_wasm_interface::Pointer\">Pointer</a>&lt;T&gt;</h4></section></summary><div class=\"docblock\"><p>Create a null pointer.</p>\n</div></details><details class=\"toggle method-toggle\" open><summary><section id=\"method.cast\" class=\"method\"><a class=\"src rightside\" href=\"src/sp_wasm_interface/lib.rs.html#186\">source</a><h4 class=\"code-header\">pub fn <a href=\"sp_wasm_interface/struct.Pointer.html#tymethod.cast\" class=\"fn\">cast</a>&lt;R&gt;(self) -&gt; <a class=\"struct\" href=\"sp_wasm_interface/struct.Pointer.html\" title=\"struct sp_wasm_interface::Pointer\">Pointer</a>&lt;R&gt;<div class=\"where\">where\n    R: <a class=\"trait\" href=\"sp_wasm_interface/trait.PointerType.html\" title=\"trait sp_wasm_interface::PointerType\">PointerType</a>,</div></h4></section></summary><div class=\"docblock\"><p>Cast this pointer of type <code>T</code> to a pointer of type <code>R</code>.</p>\n</div></details></div></details>",0,"sp_runtime_interface::Pointer"],["<details class=\"toggle implementors-toggle\" open><summary><section id=\"impl-Clone-for-Pointer%3CT%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/sp_wasm_interface/lib.rs.html#155\">source</a><a href=\"#impl-Clone-for-Pointer%3CT%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;T&gt; <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/clone/trait.Clone.html\" title=\"trait core::clone::Clone\">Clone</a> for <a class=\"struct\" href=\"sp_wasm_interface/struct.Pointer.html\" title=\"struct sp_wasm_interface::Pointer\">Pointer</a>&lt;T&gt;<div class=\"where\">where\n    T: <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/clone/trait.Clone.html\" title=\"trait core::clone::Clone\">Clone</a> + <a class=\"trait\" href=\"sp_wasm_interface/trait.PointerType.html\" title=\"trait sp_wasm_interface::PointerType\">PointerType</a>,</div></h3></section></summary><div class=\"impl-items\"><details class=\"toggle method-toggle\" open><summary><section id=\"method.clone\" class=\"method trait-impl\"><a class=\"src rightside\" href=\"src/sp_wasm_interface/lib.rs.html#155\">source</a><a href=\"#method.clone\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"https://doc.rust-lang.org/nightly/core/clone/trait.Clone.html#tymethod.clone\" class=\"fn\">clone</a>(&amp;self) -&gt; <a class=\"struct\" href=\"sp_wasm_interface/struct.Pointer.html\" title=\"struct sp_wasm_interface::Pointer\">Pointer</a>&lt;T&gt;</h4></section></summary><div class='docblock'>Returns a copy of the value. <a href=\"https://doc.rust-lang.org/nightly/core/clone/trait.Clone.html#tymethod.clone\">Read more</a></div></details><details class=\"toggle method-toggle\" open><summary><section id=\"method.clone_from\" class=\"method trait-impl\"><span class=\"rightside\"><span class=\"since\" title=\"Stable since Rust version 1.0.0\">1.0.0</span> · <a class=\"src\" href=\"https://doc.rust-lang.org/nightly/src/core/clone.rs.html#169\">source</a></span><a href=\"#method.clone_from\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"https://doc.rust-lang.org/nightly/core/clone/trait.Clone.html#method.clone_from\" class=\"fn\">clone_from</a>(&amp;mut self, source: <a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.reference.html\">&amp;Self</a>)</h4></section></summary><div class='docblock'>Performs copy-assignment from <code>source</code>. <a href=\"https://doc.rust-lang.org/nightly/core/clone/trait.Clone.html#method.clone_from\">Read more</a></div></details></div></details>","Clone","sp_runtime_interface::Pointer"],["<section id=\"impl-Copy-for-Pointer%3CT%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/sp_wasm_interface/lib.rs.html#155\">source</a><a href=\"#impl-Copy-for-Pointer%3CT%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;T&gt; <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/marker/trait.Copy.html\" title=\"trait core::marker::Copy\">Copy</a> for <a class=\"struct\" href=\"sp_wasm_interface/struct.Pointer.html\" title=\"struct sp_wasm_interface::Pointer\">Pointer</a>&lt;T&gt;<div class=\"where\">where\n    T: <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/marker/trait.Copy.html\" title=\"trait core::marker::Copy\">Copy</a> + <a class=\"trait\" href=\"sp_wasm_interface/trait.PointerType.html\" title=\"trait sp_wasm_interface::PointerType\">PointerType</a>,</div></h3></section>","Copy","sp_runtime_interface::Pointer"],["<details class=\"toggle implementors-toggle\" open><summary><section id=\"impl-From%3Cu32%3E-for-Pointer%3CT%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/sp_wasm_interface/lib.rs.html#191\">source</a><a href=\"#impl-From%3Cu32%3E-for-Pointer%3CT%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;T&gt; <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/convert/trait.From.html\" title=\"trait core::convert::From\">From</a>&lt;<a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.u32.html\">u32</a>&gt; for <a class=\"struct\" href=\"sp_wasm_interface/struct.Pointer.html\" title=\"struct sp_wasm_interface::Pointer\">Pointer</a>&lt;T&gt;<div class=\"where\">where\n    T: <a class=\"trait\" href=\"sp_wasm_interface/trait.PointerType.html\" title=\"trait sp_wasm_interface::PointerType\">PointerType</a>,</div></h3></section></summary><div class=\"impl-items\"><details class=\"toggle method-toggle\" open><summary><section id=\"method.from\" class=\"method trait-impl\"><a class=\"src rightside\" href=\"src/sp_wasm_interface/lib.rs.html#192\">source</a><a href=\"#method.from\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"https://doc.rust-lang.org/nightly/core/convert/trait.From.html#tymethod.from\" class=\"fn\">from</a>(ptr: <a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.u32.html\">u32</a>) -&gt; <a class=\"struct\" href=\"sp_wasm_interface/struct.Pointer.html\" title=\"struct sp_wasm_interface::Pointer\">Pointer</a>&lt;T&gt;</h4></section></summary><div class='docblock'>Converts to this type from the input type.</div></details></div></details>","From<u32>","sp_runtime_interface::Pointer"],["<section id=\"impl-StructuralEq-for-Pointer%3CT%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/sp_wasm_interface/lib.rs.html#155\">source</a><a href=\"#impl-StructuralEq-for-Pointer%3CT%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;T&gt; <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/marker/trait.StructuralEq.html\" title=\"trait core::marker::StructuralEq\">StructuralEq</a> for <a class=\"struct\" href=\"sp_wasm_interface/struct.Pointer.html\" title=\"struct sp_wasm_interface::Pointer\">Pointer</a>&lt;T&gt;<div class=\"where\">where\n    T: <a class=\"trait\" href=\"sp_wasm_interface/trait.PointerType.html\" title=\"trait sp_wasm_interface::PointerType\">PointerType</a>,</div></h3></section>","StructuralEq","sp_runtime_interface::Pointer"],["<details class=\"toggle implementors-toggle\" open><summary><section id=\"impl-TryFromValue-for-Pointer%3CT%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/sp_wasm_interface/lib.rs.html#222\">source</a><a href=\"#impl-TryFromValue-for-Pointer%3CT%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;T&gt; <a class=\"trait\" href=\"sp_wasm_interface/trait.TryFromValue.html\" title=\"trait sp_wasm_interface::TryFromValue\">TryFromValue</a> for <a class=\"struct\" href=\"sp_wasm_interface/struct.Pointer.html\" title=\"struct sp_wasm_interface::Pointer\">Pointer</a>&lt;T&gt;<div class=\"where\">where\n    T: <a class=\"trait\" href=\"sp_wasm_interface/trait.PointerType.html\" title=\"trait sp_wasm_interface::PointerType\">PointerType</a>,</div></h3></section></summary><div class=\"impl-items\"><details class=\"toggle method-toggle\" open><summary><section id=\"method.try_from_value\" class=\"method trait-impl\"><a class=\"src rightside\" href=\"src/sp_wasm_interface/lib.rs.html#223\">source</a><a href=\"#method.try_from_value\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"sp_wasm_interface/trait.TryFromValue.html#tymethod.try_from_value\" class=\"fn\">try_from_value</a>(val: <a class=\"enum\" href=\"sp_wasm_interface/enum.Value.html\" title=\"enum sp_wasm_interface::Value\">Value</a>) -&gt; <a class=\"enum\" href=\"https://doc.rust-lang.org/nightly/core/option/enum.Option.html\" title=\"enum core::option::Option\">Option</a>&lt;<a class=\"struct\" href=\"sp_wasm_interface/struct.Pointer.html\" title=\"struct sp_wasm_interface::Pointer\">Pointer</a>&lt;T&gt;&gt;</h4></section></summary><div class='docblock'>Try to convert the given <code>Value</code> into <code>Self</code>.</div></details></div></details>","TryFromValue","sp_runtime_interface::Pointer"],["<details class=\"toggle implementors-toggle\" open><summary><section id=\"impl-Debug-for-Pointer%3CT%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/sp_wasm_interface/lib.rs.html#155\">source</a><a href=\"#impl-Debug-for-Pointer%3CT%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;T&gt; <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/fmt/trait.Debug.html\" title=\"trait core::fmt::Debug\">Debug</a> for <a class=\"struct\" href=\"sp_wasm_interface/struct.Pointer.html\" title=\"struct sp_wasm_interface::Pointer\">Pointer</a>&lt;T&gt;<div class=\"where\">where\n    T: <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/fmt/trait.Debug.html\" title=\"trait core::fmt::Debug\">Debug</a> + <a class=\"trait\" href=\"sp_wasm_interface/trait.PointerType.html\" title=\"trait sp_wasm_interface::PointerType\">PointerType</a>,</div></h3></section></summary><div class=\"impl-items\"><details class=\"toggle method-toggle\" open><summary><section id=\"method.fmt\" class=\"method trait-impl\"><a class=\"src rightside\" href=\"src/sp_wasm_interface/lib.rs.html#155\">source</a><a href=\"#method.fmt\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"https://doc.rust-lang.org/nightly/core/fmt/trait.Debug.html#tymethod.fmt\" class=\"fn\">fmt</a>(&amp;self, f: &amp;mut <a class=\"struct\" href=\"https://doc.rust-lang.org/nightly/core/fmt/struct.Formatter.html\" title=\"struct core::fmt::Formatter\">Formatter</a>&lt;'_&gt;) -&gt; <a class=\"enum\" href=\"https://doc.rust-lang.org/nightly/core/result/enum.Result.html\" title=\"enum core::result::Result\">Result</a>&lt;<a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.unit.html\">()</a>, <a class=\"struct\" href=\"https://doc.rust-lang.org/nightly/core/fmt/struct.Error.html\" title=\"struct core::fmt::Error\">Error</a>&gt;</h4></section></summary><div class='docblock'>Formats the value using the given formatter. <a href=\"https://doc.rust-lang.org/nightly/core/fmt/trait.Debug.html#tymethod.fmt\">Read more</a></div></details></div></details>","Debug","sp_runtime_interface::Pointer"],["<details class=\"toggle implementors-toggle\" open><summary><section id=\"impl-IntoValue-for-Pointer%3CT%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/sp_wasm_interface/lib.rs.html#215\">source</a><a href=\"#impl-IntoValue-for-Pointer%3CT%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;T&gt; <a class=\"trait\" href=\"sp_wasm_interface/trait.IntoValue.html\" title=\"trait sp_wasm_interface::IntoValue\">IntoValue</a> for <a class=\"struct\" href=\"sp_wasm_interface/struct.Pointer.html\" title=\"struct sp_wasm_interface::Pointer\">Pointer</a>&lt;T&gt;<div class=\"where\">where\n    T: <a class=\"trait\" href=\"sp_wasm_interface/trait.PointerType.html\" title=\"trait sp_wasm_interface::PointerType\">PointerType</a>,</div></h3></section></summary><div class=\"impl-items\"><details class=\"toggle\" open><summary><section id=\"associatedconstant.VALUE_TYPE\" class=\"associatedconstant trait-impl\"><a class=\"src rightside\" href=\"src/sp_wasm_interface/lib.rs.html#216\">source</a><a href=\"#associatedconstant.VALUE_TYPE\" class=\"anchor\">§</a><h4 class=\"code-header\">const <a href=\"sp_wasm_interface/trait.IntoValue.html#associatedconstant.VALUE_TYPE\" class=\"constant\">VALUE_TYPE</a>: <a class=\"enum\" href=\"sp_wasm_interface/enum.ValueType.html\" title=\"enum sp_wasm_interface::ValueType\">ValueType</a> = ValueType::I32</h4></section></summary><div class='docblock'>The type of the value in wasm.</div></details><details class=\"toggle method-toggle\" open><summary><section id=\"method.into_value\" class=\"method trait-impl\"><a class=\"src rightside\" href=\"src/sp_wasm_interface/lib.rs.html#217\">source</a><a href=\"#method.into_value\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"sp_wasm_interface/trait.IntoValue.html#tymethod.into_value\" class=\"fn\">into_value</a>(self) -&gt; <a class=\"enum\" href=\"sp_wasm_interface/enum.Value.html\" title=\"enum sp_wasm_interface::Value\">Value</a></h4></section></summary><div class='docblock'>Convert <code>self</code> into a wasm <code>Value</code>.</div></details></div></details>","IntoValue","sp_runtime_interface::Pointer"],["<section id=\"impl-StructuralPartialEq-for-Pointer%3CT%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/sp_wasm_interface/lib.rs.html#155\">source</a><a href=\"#impl-StructuralPartialEq-for-Pointer%3CT%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;T&gt; <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/marker/trait.StructuralPartialEq.html\" title=\"trait core::marker::StructuralPartialEq\">StructuralPartialEq</a> for <a class=\"struct\" href=\"sp_wasm_interface/struct.Pointer.html\" title=\"struct sp_wasm_interface::Pointer\">Pointer</a>&lt;T&gt;<div class=\"where\">where\n    T: <a class=\"trait\" href=\"sp_wasm_interface/trait.PointerType.html\" title=\"trait sp_wasm_interface::PointerType\">PointerType</a>,</div></h3></section>","StructuralPartialEq","sp_runtime_interface::Pointer"],["<details class=\"toggle implementors-toggle\" open><summary><section id=\"impl-PartialEq-for-Pointer%3CT%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/sp_wasm_interface/lib.rs.html#155\">source</a><a href=\"#impl-PartialEq-for-Pointer%3CT%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;T&gt; <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/cmp/trait.PartialEq.html\" title=\"trait core::cmp::PartialEq\">PartialEq</a> for <a class=\"struct\" href=\"sp_wasm_interface/struct.Pointer.html\" title=\"struct sp_wasm_interface::Pointer\">Pointer</a>&lt;T&gt;<div class=\"where\">where\n    T: <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/cmp/trait.PartialEq.html\" title=\"trait core::cmp::PartialEq\">PartialEq</a> + <a class=\"trait\" href=\"sp_wasm_interface/trait.PointerType.html\" title=\"trait sp_wasm_interface::PointerType\">PointerType</a>,</div></h3></section></summary><div class=\"impl-items\"><details class=\"toggle method-toggle\" open><summary><section id=\"method.eq\" class=\"method trait-impl\"><a class=\"src rightside\" href=\"src/sp_wasm_interface/lib.rs.html#155\">source</a><a href=\"#method.eq\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"https://doc.rust-lang.org/nightly/core/cmp/trait.PartialEq.html#tymethod.eq\" class=\"fn\">eq</a>(&amp;self, other: &amp;<a class=\"struct\" href=\"sp_wasm_interface/struct.Pointer.html\" title=\"struct sp_wasm_interface::Pointer\">Pointer</a>&lt;T&gt;) -&gt; <a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.bool.html\">bool</a></h4></section></summary><div class='docblock'>This method tests for <code>self</code> and <code>other</code> values to be equal, and is used\nby <code>==</code>.</div></details><details class=\"toggle method-toggle\" open><summary><section id=\"method.ne\" class=\"method trait-impl\"><span class=\"rightside\"><span class=\"since\" title=\"Stable since Rust version 1.0.0\">1.0.0</span> · <a class=\"src\" href=\"https://doc.rust-lang.org/nightly/src/core/cmp.rs.html#242\">source</a></span><a href=\"#method.ne\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"https://doc.rust-lang.org/nightly/core/cmp/trait.PartialEq.html#method.ne\" class=\"fn\">ne</a>(&amp;self, other: <a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.reference.html\">&amp;Rhs</a>) -&gt; <a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.bool.html\">bool</a></h4></section></summary><div class='docblock'>This method tests for <code>!=</code>. The default implementation is almost always\nsufficient, and should not be overridden without very good reason.</div></details></div></details>","PartialEq","sp_runtime_interface::Pointer"],["<section id=\"impl-Eq-for-Pointer%3CT%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/sp_wasm_interface/lib.rs.html#155\">source</a><a href=\"#impl-Eq-for-Pointer%3CT%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;T&gt; <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/cmp/trait.Eq.html\" title=\"trait core::cmp::Eq\">Eq</a> for <a class=\"struct\" href=\"sp_wasm_interface/struct.Pointer.html\" title=\"struct sp_wasm_interface::Pointer\">Pointer</a>&lt;T&gt;<div class=\"where\">where\n    T: <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/cmp/trait.Eq.html\" title=\"trait core::cmp::Eq\">Eq</a> + <a class=\"trait\" href=\"sp_wasm_interface/trait.PointerType.html\" title=\"trait sp_wasm_interface::PointerType\">PointerType</a>,</div></h3></section>","Eq","sp_runtime_interface::Pointer"]]
};if (window.register_type_impls) {window.register_type_impls(type_impls);} else {window.pending_type_impls = type_impls;}})()