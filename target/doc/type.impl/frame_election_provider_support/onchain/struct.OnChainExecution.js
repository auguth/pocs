(function() {var type_impls = {
"frame_election_provider_support":[["<details class=\"toggle implementors-toggle\" open><summary><section id=\"impl-ElectionProvider-for-OnChainExecution%3CT%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/frame_election_provider_support/onchain.rs.html#172-183\">source</a><a href=\"#impl-ElectionProvider-for-OnChainExecution%3CT%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;T: <a class=\"trait\" href=\"frame_election_provider_support/onchain/trait.Config.html\" title=\"trait frame_election_provider_support::onchain::Config\">Config</a>&gt; <a class=\"trait\" href=\"frame_election_provider_support/trait.ElectionProvider.html\" title=\"trait frame_election_provider_support::ElectionProvider\">ElectionProvider</a> for <a class=\"struct\" href=\"frame_election_provider_support/onchain/struct.OnChainExecution.html\" title=\"struct frame_election_provider_support::onchain::OnChainExecution\">OnChainExecution</a>&lt;T&gt;</h3></section></summary><div class=\"impl-items\"><details class=\"toggle method-toggle\" open><summary><section id=\"method.ongoing\" class=\"method trait-impl\"><a class=\"src rightside\" href=\"src/frame_election_provider_support/onchain.rs.html#173-175\">source</a><a href=\"#method.ongoing\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"frame_election_provider_support/trait.ElectionProvider.html#tymethod.ongoing\" class=\"fn\">ongoing</a>() -&gt; <a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.bool.html\">bool</a></h4></section></summary><div class='docblock'>Indicate if this election provider is currently ongoing an asynchronous election or not.</div></details><details class=\"toggle method-toggle\" open><summary><section id=\"method.elect\" class=\"method trait-impl\"><a class=\"src rightside\" href=\"src/frame_election_provider_support/onchain.rs.html#177-182\">source</a><a href=\"#method.elect\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"frame_election_provider_support/trait.ElectionProvider.html#tymethod.elect\" class=\"fn\">elect</a>() -&gt; <a class=\"enum\" href=\"https://doc.rust-lang.org/nightly/core/result/enum.Result.html\" title=\"enum core::result::Result\">Result</a>&lt;<a class=\"type\" href=\"frame_election_provider_support/type.BoundedSupportsOf.html\" title=\"type frame_election_provider_support::BoundedSupportsOf\">BoundedSupportsOf</a>&lt;Self&gt;, Self::<a class=\"associatedtype\" href=\"frame_election_provider_support/trait.ElectionProviderBase.html#associatedtype.Error\" title=\"type frame_election_provider_support::ElectionProviderBase::Error\">Error</a>&gt;</h4></section></summary><div class='docblock'>Performs the election. This should be implemented as a self-weighing function. The\nimplementor should register its appropriate weight at the end of execution with the\nsystem pallet directly.</div></details></div></details>","ElectionProvider","frame_election_provider_support::onchain::BoundedExecution"],["<details class=\"toggle implementors-toggle\" open><summary><section id=\"impl-InstantElectionProvider-for-OnChainExecution%3CT%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/frame_election_provider_support/onchain.rs.html#160-170\">source</a><a href=\"#impl-InstantElectionProvider-for-OnChainExecution%3CT%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;T: <a class=\"trait\" href=\"frame_election_provider_support/onchain/trait.Config.html\" title=\"trait frame_election_provider_support::onchain::Config\">Config</a>&gt; <a class=\"trait\" href=\"frame_election_provider_support/trait.InstantElectionProvider.html\" title=\"trait frame_election_provider_support::InstantElectionProvider\">InstantElectionProvider</a> for <a class=\"struct\" href=\"frame_election_provider_support/onchain/struct.OnChainExecution.html\" title=\"struct frame_election_provider_support::onchain::OnChainExecution\">OnChainExecution</a>&lt;T&gt;</h3></section></summary><div class=\"impl-items\"><section id=\"method.instant_elect\" class=\"method trait-impl\"><a class=\"src rightside\" href=\"src/frame_election_provider_support/onchain.rs.html#161-169\">source</a><a href=\"#method.instant_elect\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"frame_election_provider_support/trait.InstantElectionProvider.html#tymethod.instant_elect\" class=\"fn\">instant_elect</a>(\n    forced_input_voters_bound: <a class=\"enum\" href=\"https://doc.rust-lang.org/nightly/core/option/enum.Option.html\" title=\"enum core::option::Option\">Option</a>&lt;<a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.u32.html\">u32</a>&gt;,\n    forced_input_target_bound: <a class=\"enum\" href=\"https://doc.rust-lang.org/nightly/core/option/enum.Option.html\" title=\"enum core::option::Option\">Option</a>&lt;<a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.u32.html\">u32</a>&gt;\n) -&gt; <a class=\"enum\" href=\"https://doc.rust-lang.org/nightly/core/result/enum.Result.html\" title=\"enum core::result::Result\">Result</a>&lt;<a class=\"type\" href=\"frame_election_provider_support/type.BoundedSupportsOf.html\" title=\"type frame_election_provider_support::BoundedSupportsOf\">BoundedSupportsOf</a>&lt;Self&gt;, Self::<a class=\"associatedtype\" href=\"frame_election_provider_support/trait.ElectionProviderBase.html#associatedtype.Error\" title=\"type frame_election_provider_support::ElectionProviderBase::Error\">Error</a>&gt;</h4></section></div></details>","InstantElectionProvider","frame_election_provider_support::onchain::BoundedExecution"],["<details class=\"toggle implementors-toggle\" open><summary><section id=\"impl-ElectionProviderBase-for-OnChainExecution%3CT%3E\" class=\"impl\"><a class=\"src rightside\" href=\"src/frame_election_provider_support/onchain.rs.html#152-158\">source</a><a href=\"#impl-ElectionProviderBase-for-OnChainExecution%3CT%3E\" class=\"anchor\">§</a><h3 class=\"code-header\">impl&lt;T: <a class=\"trait\" href=\"frame_election_provider_support/onchain/trait.Config.html\" title=\"trait frame_election_provider_support::onchain::Config\">Config</a>&gt; <a class=\"trait\" href=\"frame_election_provider_support/trait.ElectionProviderBase.html\" title=\"trait frame_election_provider_support::ElectionProviderBase\">ElectionProviderBase</a> for <a class=\"struct\" href=\"frame_election_provider_support/onchain/struct.OnChainExecution.html\" title=\"struct frame_election_provider_support::onchain::OnChainExecution\">OnChainExecution</a>&lt;T&gt;</h3></section></summary><div class=\"impl-items\"><details class=\"toggle\" open><summary><section id=\"associatedtype.AccountId\" class=\"associatedtype trait-impl\"><a href=\"#associatedtype.AccountId\" class=\"anchor\">§</a><h4 class=\"code-header\">type <a href=\"frame_election_provider_support/trait.ElectionProviderBase.html#associatedtype.AccountId\" class=\"associatedtype\">AccountId</a> = &lt;&lt;T as <a class=\"trait\" href=\"frame_election_provider_support/onchain/trait.Config.html\" title=\"trait frame_election_provider_support::onchain::Config\">Config</a>&gt;::<a class=\"associatedtype\" href=\"frame_election_provider_support/onchain/trait.Config.html#associatedtype.System\" title=\"type frame_election_provider_support::onchain::Config::System\">System</a> as <a class=\"trait\" href=\"frame_system/pallet/trait.Config.html\" title=\"trait frame_system::pallet::Config\">Config</a>&gt;::<a class=\"associatedtype\" href=\"frame_system/pallet/trait.Config.html#associatedtype.AccountId\" title=\"type frame_system::pallet::Config::AccountId\">AccountId</a></h4></section></summary><div class='docblock'>The account identifier type.</div></details><details class=\"toggle\" open><summary><section id=\"associatedtype.BlockNumber\" class=\"associatedtype trait-impl\"><a href=\"#associatedtype.BlockNumber\" class=\"anchor\">§</a><h4 class=\"code-header\">type <a href=\"frame_election_provider_support/trait.ElectionProviderBase.html#associatedtype.BlockNumber\" class=\"associatedtype\">BlockNumber</a> = &lt;&lt;&lt;&lt;T as <a class=\"trait\" href=\"frame_election_provider_support/onchain/trait.Config.html\" title=\"trait frame_election_provider_support::onchain::Config\">Config</a>&gt;::<a class=\"associatedtype\" href=\"frame_election_provider_support/onchain/trait.Config.html#associatedtype.System\" title=\"type frame_election_provider_support::onchain::Config::System\">System</a> as <a class=\"trait\" href=\"frame_system/pallet/trait.Config.html\" title=\"trait frame_system::pallet::Config\">Config</a>&gt;::<a class=\"associatedtype\" href=\"frame_system/pallet/trait.Config.html#associatedtype.Block\" title=\"type frame_system::pallet::Config::Block\">Block</a> as HeaderProvider&gt;::HeaderT as <a class=\"trait\" href=\"sp_runtime/traits/trait.Header.html\" title=\"trait sp_runtime::traits::Header\">Header</a>&gt;::<a class=\"associatedtype\" href=\"sp_runtime/traits/trait.Header.html#associatedtype.Number\" title=\"type sp_runtime::traits::Header::Number\">Number</a></h4></section></summary><div class='docblock'>The block number type.</div></details><details class=\"toggle\" open><summary><section id=\"associatedtype.Error\" class=\"associatedtype trait-impl\"><a href=\"#associatedtype.Error\" class=\"anchor\">§</a><h4 class=\"code-header\">type <a href=\"frame_election_provider_support/trait.ElectionProviderBase.html#associatedtype.Error\" class=\"associatedtype\">Error</a> = <a class=\"enum\" href=\"frame_election_provider_support/onchain/enum.Error.html\" title=\"enum frame_election_provider_support::onchain::Error\">Error</a></h4></section></summary><div class='docblock'>The error type that is returned by the provider.</div></details><details class=\"toggle\" open><summary><section id=\"associatedtype.MaxWinners\" class=\"associatedtype trait-impl\"><a href=\"#associatedtype.MaxWinners\" class=\"anchor\">§</a><h4 class=\"code-header\">type <a href=\"frame_election_provider_support/trait.ElectionProviderBase.html#associatedtype.MaxWinners\" class=\"associatedtype\">MaxWinners</a> = &lt;T as <a class=\"trait\" href=\"frame_election_provider_support/onchain/trait.Config.html\" title=\"trait frame_election_provider_support::onchain::Config\">Config</a>&gt;::<a class=\"associatedtype\" href=\"frame_election_provider_support/onchain/trait.Config.html#associatedtype.MaxWinners\" title=\"type frame_election_provider_support::onchain::Config::MaxWinners\">MaxWinners</a></h4></section></summary><div class='docblock'>The upper bound on election winners that can be returned. <a href=\"frame_election_provider_support/trait.ElectionProviderBase.html#associatedtype.MaxWinners\">Read more</a></div></details><details class=\"toggle\" open><summary><section id=\"associatedtype.DataProvider\" class=\"associatedtype trait-impl\"><a href=\"#associatedtype.DataProvider\" class=\"anchor\">§</a><h4 class=\"code-header\">type <a href=\"frame_election_provider_support/trait.ElectionProviderBase.html#associatedtype.DataProvider\" class=\"associatedtype\">DataProvider</a> = &lt;T as <a class=\"trait\" href=\"frame_election_provider_support/onchain/trait.Config.html\" title=\"trait frame_election_provider_support::onchain::Config\">Config</a>&gt;::<a class=\"associatedtype\" href=\"frame_election_provider_support/onchain/trait.Config.html#associatedtype.DataProvider\" title=\"type frame_election_provider_support::onchain::Config::DataProvider\">DataProvider</a></h4></section></summary><div class='docblock'>The data provider of the election.</div></details><details class=\"toggle method-toggle\" open><summary><section id=\"method.desired_targets_checked\" class=\"method trait-impl\"><a class=\"src rightside\" href=\"src/frame_election_provider_support/lib.rs.html#392-400\">source</a><a href=\"#method.desired_targets_checked\" class=\"anchor\">§</a><h4 class=\"code-header\">fn <a href=\"frame_election_provider_support/trait.ElectionProviderBase.html#method.desired_targets_checked\" class=\"fn\">desired_targets_checked</a>() -&gt; <a class=\"type\" href=\"frame_election_provider_support/data_provider/type.Result.html\" title=\"type frame_election_provider_support::data_provider::Result\">Result</a>&lt;<a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.u32.html\">u32</a>&gt;</h4></section></summary><div class='docblock'>checked call to <code>Self::DataProvider::desired_targets()</code> ensuring the value never exceeds\n<a href=\"frame_election_provider_support/trait.ElectionProviderBase.html#associatedtype.MaxWinners\"><code>Self::MaxWinners</code></a>.</div></details></div></details>","ElectionProviderBase","frame_election_provider_support::onchain::BoundedExecution"]]
};if (window.register_type_impls) {window.register_type_impls(type_impls);} else {window.pending_type_impls = type_impls;}})()