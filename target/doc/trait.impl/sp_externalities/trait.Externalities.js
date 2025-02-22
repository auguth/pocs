(function() {var implementors = {
"sp_state_machine":[["impl&lt;'a, H, B&gt; <a class=\"trait\" href=\"sp_externalities/trait.Externalities.html\" title=\"trait sp_externalities::Externalities\">Externalities</a> for <a class=\"struct\" href=\"sp_state_machine/struct.Ext.html\" title=\"struct sp_state_machine::Ext\">Ext</a>&lt;'a, H, B&gt;<div class=\"where\">where\n    H: <a class=\"trait\" href=\"hash_db/trait.Hasher.html\" title=\"trait hash_db::Hasher\">Hasher</a>,\n    H::<a class=\"associatedtype\" href=\"hash_db/trait.Hasher.html#associatedtype.Out\" title=\"type hash_db::Hasher::Out\">Out</a>: <a class=\"trait\" href=\"https://doc.rust-lang.org/nightly/core/cmp/trait.Ord.html\" title=\"trait core::cmp::Ord\">Ord</a> + 'static + <a class=\"trait\" href=\"parity_scale_codec/codec/trait.Codec.html\" title=\"trait parity_scale_codec::codec::Codec\">Codec</a>,\n    B: <a class=\"trait\" href=\"sp_state_machine/backend/trait.Backend.html\" title=\"trait sp_state_machine::backend::Backend\">Backend</a>&lt;H&gt;,</div>"],["impl&lt;'a, H: <a class=\"trait\" href=\"hash_db/trait.Hasher.html\" title=\"trait hash_db::Hasher\">Hasher</a>, B: 'a + <a class=\"trait\" href=\"sp_state_machine/backend/trait.Backend.html\" title=\"trait sp_state_machine::backend::Backend\">Backend</a>&lt;H&gt;&gt; <a class=\"trait\" href=\"sp_externalities/trait.Externalities.html\" title=\"trait sp_externalities::Externalities\">Externalities</a> for <a class=\"struct\" href=\"sp_state_machine/struct.ReadOnlyExternalities.html\" title=\"struct sp_state_machine::ReadOnlyExternalities\">ReadOnlyExternalities</a>&lt;'a, H, B&gt;<div class=\"where\">where\n    H::<a class=\"associatedtype\" href=\"hash_db/trait.Hasher.html#associatedtype.Out\" title=\"type hash_db::Hasher::Out\">Out</a>: <a class=\"trait\" href=\"parity_scale_codec/codec/trait.Encode.html\" title=\"trait parity_scale_codec::codec::Encode\">Encode</a>,</div>"],["impl <a class=\"trait\" href=\"sp_externalities/trait.Externalities.html\" title=\"trait sp_externalities::Externalities\">Externalities</a> for <a class=\"struct\" href=\"sp_state_machine/struct.BasicExternalities.html\" title=\"struct sp_state_machine::BasicExternalities\">BasicExternalities</a>"]]
};if (window.register_implementors) {window.register_implementors(implementors);} else {window.pending_implementors = implementors;}})()