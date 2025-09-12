
// Item data table
global.item_data = [];

// Health potion entry
global.item_data[PLAYER_ITEM.health_potion] = {
    sprite: spr_health_potion, // sprite asset
    get_quantity: function() { return oPlayer.health_potion; }
};
