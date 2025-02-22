(function() {var implementors = {
"blake2":[["impl <a class=\"trait\" href=\"crypto_common/trait.OutputSizeUser.html\" title=\"trait crypto_common::OutputSizeUser\">OutputSizeUser</a> for <a class=\"struct\" href=\"blake2/struct.Blake2bVarCore.html\" title=\"struct blake2::Blake2bVarCore\">Blake2bVarCore</a>"],["impl&lt;OutSize&gt; <a class=\"trait\" href=\"crypto_common/trait.OutputSizeUser.html\" title=\"trait crypto_common::OutputSizeUser\">OutputSizeUser</a> for <a class=\"struct\" href=\"blake2/struct.Blake2sMac.html\" title=\"struct blake2::Blake2sMac\">Blake2sMac</a>&lt;OutSize&gt;<div class=\"where\">where\n    OutSize: <a class=\"trait\" href=\"generic_array/trait.ArrayLength.html\" title=\"trait generic_array::ArrayLength\">ArrayLength</a>&lt;<a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.u8.html\">u8</a>&gt; + <a class=\"trait\" href=\"typenum/type_operators/trait.IsLessOrEqual.html\" title=\"trait typenum::type_operators::IsLessOrEqual\">IsLessOrEqual</a>&lt;<a class=\"type\" href=\"typenum/generated/consts/type.U32.html\" title=\"type typenum::generated::consts::U32\">U32</a>&gt; + 'static,\n    <a class=\"type\" href=\"typenum/operator_aliases/type.LeEq.html\" title=\"type typenum::operator_aliases::LeEq\">LeEq</a>&lt;OutSize, <a class=\"type\" href=\"typenum/generated/consts/type.U32.html\" title=\"type typenum::generated::consts::U32\">U32</a>&gt;: <a class=\"trait\" href=\"typenum/marker_traits/trait.NonZero.html\" title=\"trait typenum::marker_traits::NonZero\">NonZero</a>,</div>"],["impl <a class=\"trait\" href=\"crypto_common/trait.OutputSizeUser.html\" title=\"trait crypto_common::OutputSizeUser\">OutputSizeUser</a> for <a class=\"struct\" href=\"blake2/struct.Blake2sVarCore.html\" title=\"struct blake2::Blake2sVarCore\">Blake2sVarCore</a>"],["impl&lt;OutSize&gt; <a class=\"trait\" href=\"crypto_common/trait.OutputSizeUser.html\" title=\"trait crypto_common::OutputSizeUser\">OutputSizeUser</a> for <a class=\"struct\" href=\"blake2/struct.Blake2bMac.html\" title=\"struct blake2::Blake2bMac\">Blake2bMac</a>&lt;OutSize&gt;<div class=\"where\">where\n    OutSize: <a class=\"trait\" href=\"generic_array/trait.ArrayLength.html\" title=\"trait generic_array::ArrayLength\">ArrayLength</a>&lt;<a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.u8.html\">u8</a>&gt; + <a class=\"trait\" href=\"typenum/type_operators/trait.IsLessOrEqual.html\" title=\"trait typenum::type_operators::IsLessOrEqual\">IsLessOrEqual</a>&lt;<a class=\"type\" href=\"typenum/generated/consts/type.U64.html\" title=\"type typenum::generated::consts::U64\">U64</a>&gt; + 'static,\n    <a class=\"type\" href=\"typenum/operator_aliases/type.LeEq.html\" title=\"type typenum::operator_aliases::LeEq\">LeEq</a>&lt;OutSize, <a class=\"type\" href=\"typenum/generated/consts/type.U64.html\" title=\"type typenum::generated::consts::U64\">U64</a>&gt;: <a class=\"trait\" href=\"typenum/marker_traits/trait.NonZero.html\" title=\"trait typenum::marker_traits::NonZero\">NonZero</a>,</div>"]],
"digest":[["impl&lt;T&gt; <a class=\"trait\" href=\"digest/trait.OutputSizeUser.html\" title=\"trait digest::OutputSizeUser\">OutputSizeUser</a> for <a class=\"struct\" href=\"digest/core_api/struct.CoreWrapper.html\" title=\"struct digest::core_api::CoreWrapper\">CoreWrapper</a>&lt;T&gt;<div class=\"where\">where\n    T: <a class=\"trait\" href=\"digest/core_api/trait.BufferKindUser.html\" title=\"trait digest::core_api::BufferKindUser\">BufferKindUser</a> + <a class=\"trait\" href=\"digest/trait.OutputSizeUser.html\" title=\"trait digest::OutputSizeUser\">OutputSizeUser</a>,\n    T::<a class=\"associatedtype\" href=\"digest/core_api/trait.BlockSizeUser.html#associatedtype.BlockSize\" title=\"type digest::core_api::BlockSizeUser::BlockSize\">BlockSize</a>: <a class=\"trait\" href=\"typenum/type_operators/trait.IsLess.html\" title=\"trait typenum::type_operators::IsLess\">IsLess</a>&lt;<a class=\"type\" href=\"digest/consts/type.U256.html\" title=\"type digest::consts::U256\">U256</a>&gt;,\n    <a class=\"type\" href=\"typenum/operator_aliases/type.Le.html\" title=\"type typenum::operator_aliases::Le\">Le</a>&lt;T::<a class=\"associatedtype\" href=\"digest/core_api/trait.BlockSizeUser.html#associatedtype.BlockSize\" title=\"type digest::core_api::BlockSizeUser::BlockSize\">BlockSize</a>, <a class=\"type\" href=\"digest/consts/type.U256.html\" title=\"type digest::consts::U256\">U256</a>&gt;: <a class=\"trait\" href=\"typenum/marker_traits/trait.NonZero.html\" title=\"trait typenum::marker_traits::NonZero\">NonZero</a>,</div>"],["impl&lt;T, OutSize, O&gt; <a class=\"trait\" href=\"digest/trait.OutputSizeUser.html\" title=\"trait digest::OutputSizeUser\">OutputSizeUser</a> for <a class=\"struct\" href=\"digest/core_api/struct.CtVariableCoreWrapper.html\" title=\"struct digest::core_api::CtVariableCoreWrapper\">CtVariableCoreWrapper</a>&lt;T, OutSize, O&gt;<div class=\"where\">where\n    T: <a class=\"trait\" href=\"digest/core_api/trait.VariableOutputCore.html\" title=\"trait digest::core_api::VariableOutputCore\">VariableOutputCore</a>,\n    OutSize: <a class=\"trait\" href=\"generic_array/trait.ArrayLength.html\" title=\"trait generic_array::ArrayLength\">ArrayLength</a>&lt;<a class=\"primitive\" href=\"https://doc.rust-lang.org/nightly/std/primitive.u8.html\">u8</a>&gt; + <a class=\"trait\" href=\"typenum/type_operators/trait.IsLessOrEqual.html\" title=\"trait typenum::type_operators::IsLessOrEqual\">IsLessOrEqual</a>&lt;T::<a class=\"associatedtype\" href=\"digest/trait.OutputSizeUser.html#associatedtype.OutputSize\" title=\"type digest::OutputSizeUser::OutputSize\">OutputSize</a>&gt; + 'static,\n    <a class=\"type\" href=\"typenum/operator_aliases/type.LeEq.html\" title=\"type typenum::operator_aliases::LeEq\">LeEq</a>&lt;OutSize, T::<a class=\"associatedtype\" href=\"digest/trait.OutputSizeUser.html#associatedtype.OutputSize\" title=\"type digest::OutputSizeUser::OutputSize\">OutputSize</a>&gt;: <a class=\"trait\" href=\"typenum/marker_traits/trait.NonZero.html\" title=\"trait typenum::marker_traits::NonZero\">NonZero</a>,\n    T::<a class=\"associatedtype\" href=\"digest/core_api/trait.BlockSizeUser.html#associatedtype.BlockSize\" title=\"type digest::core_api::BlockSizeUser::BlockSize\">BlockSize</a>: <a class=\"trait\" href=\"typenum/type_operators/trait.IsLess.html\" title=\"trait typenum::type_operators::IsLess\">IsLess</a>&lt;<a class=\"type\" href=\"digest/consts/type.U256.html\" title=\"type digest::consts::U256\">U256</a>&gt;,\n    <a class=\"type\" href=\"typenum/operator_aliases/type.Le.html\" title=\"type typenum::operator_aliases::Le\">Le</a>&lt;T::<a class=\"associatedtype\" href=\"digest/core_api/trait.BlockSizeUser.html#associatedtype.BlockSize\" title=\"type digest::core_api::BlockSizeUser::BlockSize\">BlockSize</a>, <a class=\"type\" href=\"digest/consts/type.U256.html\" title=\"type digest::consts::U256\">U256</a>&gt;: <a class=\"trait\" href=\"typenum/marker_traits/trait.NonZero.html\" title=\"trait typenum::marker_traits::NonZero\">NonZero</a>,</div>"]],
"hmac":[["impl&lt;D: <a class=\"trait\" href=\"digest/digest/trait.Digest.html\" title=\"trait digest::digest::Digest\">Digest</a> + <a class=\"trait\" href=\"crypto_common/trait.BlockSizeUser.html\" title=\"trait crypto_common::BlockSizeUser\">BlockSizeUser</a>&gt; <a class=\"trait\" href=\"crypto_common/trait.OutputSizeUser.html\" title=\"trait crypto_common::OutputSizeUser\">OutputSizeUser</a> for <a class=\"struct\" href=\"hmac/struct.SimpleHmac.html\" title=\"struct hmac::SimpleHmac\">SimpleHmac</a>&lt;D&gt;"],["impl&lt;D&gt; <a class=\"trait\" href=\"crypto_common/trait.OutputSizeUser.html\" title=\"trait crypto_common::OutputSizeUser\">OutputSizeUser</a> for <a class=\"struct\" href=\"hmac/struct.HmacCore.html\" title=\"struct hmac::HmacCore\">HmacCore</a>&lt;D&gt;<div class=\"where\">where\n    D: <a class=\"trait\" href=\"digest/core_api/wrapper/trait.CoreProxy.html\" title=\"trait digest::core_api::wrapper::CoreProxy\">CoreProxy</a>,\n    D::<a class=\"associatedtype\" href=\"digest/core_api/wrapper/trait.CoreProxy.html#associatedtype.Core\" title=\"type digest::core_api::wrapper::CoreProxy::Core\">Core</a>: <a class=\"trait\" href=\"digest/digest/trait.HashMarker.html\" title=\"trait digest::digest::HashMarker\">HashMarker</a> + <a class=\"trait\" href=\"digest/core_api/trait.UpdateCore.html\" title=\"trait digest::core_api::UpdateCore\">UpdateCore</a> + <a class=\"trait\" href=\"digest/core_api/trait.FixedOutputCore.html\" title=\"trait digest::core_api::FixedOutputCore\">FixedOutputCore</a> + <a class=\"trait\" href=\"digest/core_api/trait.BufferKindUser.html\" title=\"trait digest::core_api::BufferKindUser\">BufferKindUser</a>&lt;BufferKind = <a class=\"struct\" href=\"block_buffer/struct.Eager.html\" title=\"struct block_buffer::Eager\">Eager</a>&gt; + <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/default/trait.Default.html\" title=\"trait core::default::Default\">Default</a> + <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/clone/trait.Clone.html\" title=\"trait core::clone::Clone\">Clone</a>,\n    &lt;D::<a class=\"associatedtype\" href=\"digest/core_api/wrapper/trait.CoreProxy.html#associatedtype.Core\" title=\"type digest::core_api::wrapper::CoreProxy::Core\">Core</a> as <a class=\"trait\" href=\"crypto_common/trait.BlockSizeUser.html\" title=\"trait crypto_common::BlockSizeUser\">BlockSizeUser</a>&gt;::<a class=\"associatedtype\" href=\"crypto_common/trait.BlockSizeUser.html#associatedtype.BlockSize\" title=\"type crypto_common::BlockSizeUser::BlockSize\">BlockSize</a>: <a class=\"trait\" href=\"typenum/type_operators/trait.IsLess.html\" title=\"trait typenum::type_operators::IsLess\">IsLess</a>&lt;<a class=\"type\" href=\"typenum/generated/consts/type.U256.html\" title=\"type typenum::generated::consts::U256\">U256</a>&gt;,\n    <a class=\"type\" href=\"typenum/operator_aliases/type.Le.html\" title=\"type typenum::operator_aliases::Le\">Le</a>&lt;&lt;D::<a class=\"associatedtype\" href=\"digest/core_api/wrapper/trait.CoreProxy.html#associatedtype.Core\" title=\"type digest::core_api::wrapper::CoreProxy::Core\">Core</a> as <a class=\"trait\" href=\"crypto_common/trait.BlockSizeUser.html\" title=\"trait crypto_common::BlockSizeUser\">BlockSizeUser</a>&gt;::<a class=\"associatedtype\" href=\"crypto_common/trait.BlockSizeUser.html#associatedtype.BlockSize\" title=\"type crypto_common::BlockSizeUser::BlockSize\">BlockSize</a>, <a class=\"type\" href=\"typenum/generated/consts/type.U256.html\" title=\"type typenum::generated::consts::U256\">U256</a>&gt;: <a class=\"trait\" href=\"typenum/marker_traits/trait.NonZero.html\" title=\"trait typenum::marker_traits::NonZero\">NonZero</a>,</div>"]],
"sha2":[["impl <a class=\"trait\" href=\"crypto_common/trait.OutputSizeUser.html\" title=\"trait crypto_common::OutputSizeUser\">OutputSizeUser</a> for <a class=\"struct\" href=\"sha2/struct.Sha512VarCore.html\" title=\"struct sha2::Sha512VarCore\">Sha512VarCore</a>"],["impl <a class=\"trait\" href=\"crypto_common/trait.OutputSizeUser.html\" title=\"trait crypto_common::OutputSizeUser\">OutputSizeUser</a> for <a class=\"struct\" href=\"sha2/struct.Sha256VarCore.html\" title=\"struct sha2::Sha256VarCore\">Sha256VarCore</a>"]],
"sha3":[["impl <a class=\"trait\" href=\"crypto_common/trait.OutputSizeUser.html\" title=\"trait crypto_common::OutputSizeUser\">OutputSizeUser</a> for <a class=\"struct\" href=\"sha3/struct.Keccak512Core.html\" title=\"struct sha3::Keccak512Core\">Keccak512Core</a>"],["impl <a class=\"trait\" href=\"crypto_common/trait.OutputSizeUser.html\" title=\"trait crypto_common::OutputSizeUser\">OutputSizeUser</a> for <a class=\"struct\" href=\"sha3/struct.Keccak224Core.html\" title=\"struct sha3::Keccak224Core\">Keccak224Core</a>"],["impl <a class=\"trait\" href=\"crypto_common/trait.OutputSizeUser.html\" title=\"trait crypto_common::OutputSizeUser\">OutputSizeUser</a> for <a class=\"struct\" href=\"sha3/struct.Keccak384Core.html\" title=\"struct sha3::Keccak384Core\">Keccak384Core</a>"],["impl <a class=\"trait\" href=\"crypto_common/trait.OutputSizeUser.html\" title=\"trait crypto_common::OutputSizeUser\">OutputSizeUser</a> for <a class=\"struct\" href=\"sha3/struct.Sha3_224Core.html\" title=\"struct sha3::Sha3_224Core\">Sha3_224Core</a>"],["impl <a class=\"trait\" href=\"crypto_common/trait.OutputSizeUser.html\" title=\"trait crypto_common::OutputSizeUser\">OutputSizeUser</a> for <a class=\"struct\" href=\"sha3/struct.Sha3_384Core.html\" title=\"struct sha3::Sha3_384Core\">Sha3_384Core</a>"],["impl <a class=\"trait\" href=\"crypto_common/trait.OutputSizeUser.html\" title=\"trait crypto_common::OutputSizeUser\">OutputSizeUser</a> for <a class=\"struct\" href=\"sha3/struct.Sha3_256Core.html\" title=\"struct sha3::Sha3_256Core\">Sha3_256Core</a>"],["impl <a class=\"trait\" href=\"crypto_common/trait.OutputSizeUser.html\" title=\"trait crypto_common::OutputSizeUser\">OutputSizeUser</a> for <a class=\"struct\" href=\"sha3/struct.Sha3_512Core.html\" title=\"struct sha3::Sha3_512Core\">Sha3_512Core</a>"],["impl <a class=\"trait\" href=\"crypto_common/trait.OutputSizeUser.html\" title=\"trait crypto_common::OutputSizeUser\">OutputSizeUser</a> for <a class=\"struct\" href=\"sha3/struct.Keccak256FullCore.html\" title=\"struct sha3::Keccak256FullCore\">Keccak256FullCore</a>"],["impl <a class=\"trait\" href=\"crypto_common/trait.OutputSizeUser.html\" title=\"trait crypto_common::OutputSizeUser\">OutputSizeUser</a> for <a class=\"struct\" href=\"sha3/struct.Keccak256Core.html\" title=\"struct sha3::Keccak256Core\">Keccak256Core</a>"]],
"twox_hash":[["impl <a class=\"trait\" href=\"crypto_common/trait.OutputSizeUser.html\" title=\"trait crypto_common::OutputSizeUser\">OutputSizeUser</a> for <a class=\"struct\" href=\"twox_hash/xxh3/struct.Hash64.html\" title=\"struct twox_hash::xxh3::Hash64\">Hash64</a>"],["impl <a class=\"trait\" href=\"crypto_common/trait.OutputSizeUser.html\" title=\"trait crypto_common::OutputSizeUser\">OutputSizeUser</a> for <a class=\"struct\" href=\"twox_hash/struct.XxHash64.html\" title=\"struct twox_hash::XxHash64\">XxHash64</a>"],["impl <a class=\"trait\" href=\"crypto_common/trait.OutputSizeUser.html\" title=\"trait crypto_common::OutputSizeUser\">OutputSizeUser</a> for <a class=\"struct\" href=\"twox_hash/xxh3/struct.Hash128.html\" title=\"struct twox_hash::xxh3::Hash128\">Hash128</a>"],["impl <a class=\"trait\" href=\"crypto_common/trait.OutputSizeUser.html\" title=\"trait crypto_common::OutputSizeUser\">OutputSizeUser</a> for <a class=\"struct\" href=\"twox_hash/struct.XxHash32.html\" title=\"struct twox_hash::XxHash32\">XxHash32</a>"]]
};if (window.register_implementors) {window.register_implementors(implementors);} else {window.pending_implementors = implementors;}})()