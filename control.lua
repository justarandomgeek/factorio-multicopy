local function OnPastedSettings(event,alt)
  if event.item == "multicopy-tool" then
    local player = game.players[event.player_index]
    local source = player.entity_copy_source
    if source then
      for _,ent in pairs(event.entities) do
        -- normal select: paste to same entity name only
        -- alt select: paste to any compatible
        if alt or (source.name == ent.name) then
          game.raise_event(defines.events.on_pre_entity_settings_pasted,{source=source,destination=ent})
          local items = ent.copy_settings(source)
          for name,count in pairs(items) do
            local itement = ent.surface.create_entity{force=ent.force,position=ent.position,name="item-on-ground",stack={name=name,count=count}}
            itement.order_deconstruction(ent.force)
          end
          game.raise_event(defines.events.on_entity_settings_pasted,{source=source,destination=ent})
        end
      end
    end
  end
end

script.on_event(defines.events.on_player_selected_area, function(event)
  OnPastedSettings(event,false)
end)

script.on_event(defines.events.on_player_alt_selected_area, function(event)
  OnPastedSettings(event,true)
end)
