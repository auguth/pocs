(function() {var type_impls = {
"frame_support":[["<details class=\"toggle implementors-toggle\" open><summary><section id=\"impl-EnsureOrigin%3COuterOrigin%3E-for-EitherOfDiverse%3CL,+R%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/frame_support/traits/dispatch.rs.html#331-344\">source</a><a href=\"#impl-EnsureOrigin%3COuterOrigin%3E-for-EitherOfDiverse%3CL,+R%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;OuterOrigin, L: <a class=\"trait\" href=\"frame_support/traits/trait.EnsureOrigin.html\" title=\"trait frame_support::traits::EnsureOrigin\">EnsureOrigin</a>&lt;OuterOrigin&gt;, R: <a class=\"trait\" href=\"frame_support/traits/trait.EnsureOrigin.html\" title=\"trait frame_support::traits::EnsureOrigin\">EnsureOrigin</a>&lt;OuterOrigin&gt;&gt; <a class=\"trait\" href=\"frame_support/traits/trait.EnsureOrigin.html\" title=\"trait frame_support::traits::EnsureOrigin\">EnsureOrigin</a>&lt;OuterOrigin&gt; for <a class=\"struct\" href=\"frame_support/traits/struct.EitherOfDiverse.html\" title=\"struct frame_support::traits::EitherOfDiverse\">EitherOfDiverse</a>&lt;L, R&gt;</h3></section></summary><div class=\"impl-items\"><details class=\"toggle\" open><summary><section id=\"associatedtype.Success\" class=\"associatedtype trait-impl\"><a href=\"#associatedtype.Success\" class=\"anchor\">§</a><h4 class=\"code-header\">type <a href=\"frame_support/traits/trait.EnsureOrigin.html#associatedtype.Success\" class=\"associatedtype\">Success</a> = <a class=\"enum\" href=\"either/enum.Either.html\" title=\"enum either::Either\">Either</a>&lt;&lt;L as <a class=\"trait\" href=\"frame_support/traits/trait.EnsureOrigin.html\" title=\"trait frame_support::traits::EnsureOrigin\">EnsureOrigin</a>&lt;OuterOrigin&gt;&gt;::<a class=\"associatedtype\" href=\"frame_support/traits/trait.EnsureOrigin.html#associatedtype.Success\" title=\"type frame_support::traits::EnsureOrigin::Success\">Success</a>, &lt;R as <a class=\"trait\" href=\"frame_support/traits/trait.EnsureOrigin.html\" title=\"trait frame_support::traits::EnsureOrigin\">EnsureOrigin</a>&lt;OuterOrigin&gt;&gt;::<a class=\"associatedtype\" href=\"frame_support/traits/trait.EnsureOrigin.html#associatedtype.Success\" title=\"type frame_support::traits::EnsureOrigin::Success\">Success</a>&gt;</h4></section></summary><div class='docblock'>A return type.</div></details><details class=\"toggle method-toggle\" open><summary><section id=\"method.try_origin\" class=\"method trait-impl\"><a class=\"src rightside\" href=\"src/frame_support/traits/dispatch.rs.html#335-338\">source</a><a href=\"#method.try_origin\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"frame_support/traits/trait.EnsureOrigin.html#tymethod.try_origin\" class=\"fn\">try_origin</a>(o: OuterOrigin) -&gt; <a class=\"enum\" href=\"frame_support/dispatch/result/enum.Result.html\" title=\"enum frame_support::dispatch::result::Result\">Result</a>&lt;Self::<a class=\"associatedtype\" href=\"frame_support/traits/trait.EnsureOrigin.html#associatedtype.Success\" title=\"type frame_support::traits::EnsureOrigin::Success\">Success</a>, OuterOrigin&gt;</h4></section></summary><div class='docblock'>Perform the origin check.</div></details><details class=\"toggle method-toggle\" open><summary><section id=\"method.ensure_origin\" class=\"method trait-impl\"><a class=\"src rightside\" href=\"src/frame_support/traits/dispatch.rs.html#36-38\">source</a><a href=\"#method.ensure_origin\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"frame_support/traits/trait.EnsureOrigin.html#method.ensure_origin\" class=\"fn\">ensure_origin</a>(o: OuterOrigin) -&gt; <a class=\"enum\" href=\"frame_support/dispatch/result/enum.Result.html\" title=\"enum frame_support::dispatch::result::Result\">Result</a>&lt;Self::<a class=\"associatedtype\" href=\"frame_support/traits/trait.EnsureOrigin.html#associatedtype.Success\" title=\"type frame_support::traits::EnsureOrigin::Success\">Success</a>, <a class=\"struct\" href=\"sp_runtime/traits/struct.BadOrigin.html\" title=\"struct sp_runtime::traits::BadOrigin\">BadOrigin</a>&gt;</h4></section></summary><div class='docblock'>Perform the origin check.</div></details></div></details>","EnsureOrigin<OuterOrigin>","frame_support::traits::dispatch::EnsureOneOf"],["<details class=\"toggle implementors-toggle\" open><summary><section id=\"impl-EnsureOriginWithArg%3COuterOrigin,+Argument%3E-for-EitherOfDiverse%3CL,+R%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/frame_support/traits/dispatch.rs.html#345-362\">source</a><a href=\"#impl-EnsureOriginWithArg%3COuterOrigin,+Argument%3E-for-EitherOfDiverse%3CL,+R%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;OuterOrigin, L: <a class=\"trait\" href=\"frame_support/traits/trait.EnsureOriginWithArg.html\" title=\"trait frame_support::traits::EnsureOriginWithArg\">EnsureOriginWithArg</a>&lt;OuterOrigin, Argument&gt;, R: <a class=\"trait\" href=\"frame_support/traits/trait.EnsureOriginWithArg.html\" title=\"trait frame_support::traits::EnsureOriginWithArg\">EnsureOriginWithArg</a>&lt;OuterOrigin, Argument&gt;, Argument&gt; <a class=\"trait\" href=\"frame_support/traits/trait.EnsureOriginWithArg.html\" title=\"trait frame_support::traits::EnsureOriginWithArg\">EnsureOriginWithArg</a>&lt;OuterOrigin, Argument&gt; for <a class=\"struct\" href=\"frame_support/traits/struct.EitherOfDiverse.html\" title=\"struct frame_support::traits::EitherOfDiverse\">EitherOfDiverse</a>&lt;L, R&gt;</h3></section></summary><div class=\"impl-items\"><details class=\"toggle\" open><summary><section id=\"associatedtype.Success\" class=\"associatedtype trait-impl\"><a href=\"#associatedtype.Success\" class=\"anchor\">§</a><h4 class=\"code-header\">type <a href=\"frame_support/traits/trait.EnsureOriginWithArg.html#associatedtype.Success\" class=\"associatedtype\">Success</a> = <a class=\"enum\" href=\"either/enum.Either.html\" title=\"enum either::Either\">Either</a>&lt;&lt;L as <a class=\"trait\" href=\"frame_support/traits/trait.EnsureOriginWithArg.html\" title=\"trait frame_support::traits::EnsureOriginWithArg\">EnsureOriginWithArg</a>&lt;OuterOrigin, Argument&gt;&gt;::<a class=\"associatedtype\" href=\"frame_support/traits/trait.EnsureOriginWithArg.html#associatedtype.Success\" title=\"type frame_support::traits::EnsureOriginWithArg::Success\">Success</a>, &lt;R as <a class=\"trait\" href=\"frame_support/traits/trait.EnsureOriginWithArg.html\" title=\"trait frame_support::traits::EnsureOriginWithArg\">EnsureOriginWithArg</a>&lt;OuterOrigin, Argument&gt;&gt;::<a class=\"associatedtype\" href=\"frame_support/traits/trait.EnsureOriginWithArg.html#associatedtype.Success\" title=\"type frame_support::traits::EnsureOriginWithArg::Success\">Success</a>&gt;</h4></section></summary><div class='docblock'>A return type.</div></details><details class=\"toggle method-toggle\" open><summary><section id=\"method.try_origin\" class=\"method trait-impl\"><a class=\"src rightside\" href=\"src/frame_support/traits/dispatch.rs.html#353-356\">source</a><a href=\"#method.try_origin\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"frame_support/traits/trait.EnsureOriginWithArg.html#tymethod.try_origin\" class=\"fn\">try_origin</a>(\n    o: OuterOrigin,\n    a: <a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.reference.html\">&amp;Argument</a>\n) -&gt; <a class=\"enum\" href=\"frame_support/dispatch/result/enum.Result.html\" title=\"enum frame_support::dispatch::result::Result\">Result</a>&lt;Self::<a class=\"associatedtype\" href=\"frame_support/traits/trait.EnsureOriginWithArg.html#associatedtype.Success\" title=\"type frame_support::traits::EnsureOriginWithArg::Success\">Success</a>, OuterOrigin&gt;</h4></section></summary><div class='docblock'>Perform the origin check, returning the origin value if unsuccessful. This allows chaining.</div></details><details class=\"toggle method-toggle\" open><summary><section id=\"method.ensure_origin\" class=\"method trait-impl\"><a class=\"src rightside\" href=\"src/frame_support/traits/dispatch.rs.html#141-143\">source</a><a href=\"#method.ensure_origin\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"frame_support/traits/trait.EnsureOriginWithArg.html#method.ensure_origin\" class=\"fn\">ensure_origin</a>(\n    o: OuterOrigin,\n    a: <a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.reference.html\">&amp;Argument</a>\n) -&gt; <a class=\"enum\" href=\"frame_support/dispatch/result/enum.Result.html\" title=\"enum frame_support::dispatch::result::Result\">Result</a>&lt;Self::<a class=\"associatedtype\" href=\"frame_support/traits/trait.EnsureOriginWithArg.html#associatedtype.Success\" title=\"type frame_support::traits::EnsureOriginWithArg::Success\">Success</a>, <a class=\"struct\" href=\"sp_runtime/traits/struct.BadOrigin.html\" title=\"struct sp_runtime::traits::BadOrigin\">BadOrigin</a>&gt;</h4></section></summary><div class='docblock'>Perform the origin check.</div></details></div></details>","EnsureOriginWithArg<OuterOrigin, Argument>","frame_support::traits::dispatch::EnsureOneOf"]]
};if (window.register_type_impls) {window.register_type_impls(type_impls);} else {window.pending_type_impls = type_impls;}})()