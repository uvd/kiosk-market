/// Example of an unlimited "Sui Hero" collection - anyone can
/// mint their Hero. Shows how to initialize the `Publisher` and how
/// to use it to get the `Display<Hero>` object - a way to describe a
/// type for the ecosystem.
module pub_nft::nft {
    use std::string::{utf8, String};

    use sui::object::{Self, UID};
    use sui::package;
    use sui::transfer::public_transfer;
    use sui::tx_context::{sender, TxContext};

    // The creator bundle: these two packages often go together.
    /// The Hero - an outstanding collection of digital art.
    struct Hero has key, store {
        id: UID,
        name: String,
        img_url: String,
    }

    /// One-Time-Witness for the module.
    struct NFT has drop {}

    /// In the module initializer one claims the `Publisher` object
    /// to then create a `Display`. The `Display` is initialized with
    /// a set of fields (but can be modified later) and published via
    /// the `update_version` call.
    ///
    /// Keys and values are set in the initializer but could also be
    /// set after publishing if a `Publisher` object was created.
    fun init(otw: NFT, ctx: &mut TxContext) {
        let keys = vector[
            utf8(b"name"),
            utf8(b"link"),
            utf8(b"image_url"),
            utf8(b"description"),
            utf8(b"project_url"),
            utf8(b"creator"),
        ];

        let values = vector[
            // For `name` one can use the `Hero.name` property
            utf8(b"{name}"),
            // For `link` one can build a URL using an `id` property
            utf8(b"https://sui-heroes.io/hero/{id}"),
            // For `image_url` use an IPFS template + `img_url` property.
            utf8(b"ipfs://{img_url}"),
            // Description is static for all `Hero` objects.
            utf8(b"A true Hero of the Sui ecosystem!"),
            // Project URL is usually static
            utf8(b"https://sui-heroes.io"),
            // Creator field can be any
            utf8(b"Unknown Sui Fan")
        ];

        // Claim the `Publisher` for the package!
        let publisher = package::claim(otw, ctx);

        // Get a new `Display` object for the `Hero` type.
        let display = display::new_with_fields<Hero>(
            &publisher, keys, values, ctx
        );

        // Commit first version of `Display` to apply changes.
        display::update_version(&mut display);

        public_transfer(publisher, sender(ctx));
        public_transfer(display, sender(ctx));
    }

    /// Anyone can mint their `Hero`!
    public fun mint(name: String, img_url: String, ctx: &mut TxContext): Hero {
        let id = object::new(ctx);
        Hero { id, name, img_url }
    }

    public entry fun mint_me(name: String, img_url: String, ctx: &mut TxContext) {
        let id = object::new(ctx);
        let hero = Hero { id, name, img_url };
        public_transfer(hero, sender(ctx));
    }
}