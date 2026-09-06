'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/assets/data/cfe.json": "edadc4d0567df3b23b3a58ed7885154e",
"assets/assets/audio/manifest.json": "8e9cf51245041896283a7d295e983f76",
"assets/assets/audio/en-US/remote_control.mp3": "c209920a4480d9001cce106c15e90510",
"assets/assets/audio/en-US/i_ll_change_the_batteries.mp3": "c706f3a3232984b328a4cb0620f07cc3",
"assets/assets/audio/en-US/usb_c_hub.mp3": "8ebb3624b0f9099802eac1654e6c62b1",
"assets/assets/audio/en-US/stapler.mp3": "26fe0ae21cc32792c2d4109e2d984089",
"assets/assets/audio/en-US/all_equipment_uses_a_surge_protector.mp3": "4a70ef7e9346b64bb8cbef3ad6a39c86",
"assets/assets/audio/en-US/we_use_tencent_meeting_for_online_students.mp3": "ed30a280a73551cf2cb5aead78e18b29",
"assets/assets/audio/en-US/the_wi_fi_password_is_on_the_podium.mp3": "6a6c368329526faf5c631f9e25a736da",
"assets/assets/audio/en-US/class_starts_at_eight.mp3": "f856434a40592abfe5589889b309d7c2",
"assets/assets/audio/en-US/please_keep_the_wireless_mic_with_you.mp3": "7343202a93e296d462591983030099c8",
"assets/assets/audio/en-US/clip_the_lapel_mic_to_your_collar.mp3": "cee9dec74ad7c752467845b66ce325dd",
"assets/assets/audio/en-US/whiteboard.mp3": "cfa5dbdf3caa6a76de9ebff835f0dd75",
"assets/assets/audio/en-US/the_projector_overheated_let_it_cool_down.mp3": "59008cf9bf1fe891b63481266026eb5e",
"assets/assets/audio/en-US/plug_it_into_the_audio_jack_here.mp3": "8e6792084df7d1895f4a691a05517c52",
"assets/assets/audio/en-US/there_s_a_power_outage_in_this_building.mp3": "960b5fcbbf9409f44ea3b9a369ddb26c",
"assets/assets/audio/en-US/there_s_no_sound_from_the_speakers.mp3": "ce790cf0fc423ffb75cb33c8ec3970db",
"assets/assets/audio/en-US/the_eraser_is_on_the_tray.mp3": "d0d87438abb98b66277d7810e4720fa6",
"assets/assets/audio/en-US/eraser.mp3": "f752fbe825b5cfe208d2cf86f11f7137",
"assets/assets/audio/en-US/is_there_a_lectern.mp3": "6dddeb166800880e6be710a3d7babeb2",
"assets/assets/audio/en-US/laptop.mp3": "2874afdedb0a07829f9c67f959241f23",
"assets/assets/audio/en-US/the_water_dispenser_is_in_the_hallway.mp3": "d94b7e6b3d5f871774897386d6cff418",
"assets/assets/audio/en-US/there_s_a_high_pitched_noise.mp3": "e431b5801c940918270d09b871ebbaec",
"assets/assets/audio/en-US/volume.mp3": "40f48db22a33cf99f9d70b4d2388e210",
"assets/assets/audio/en-US/blackboard.mp3": "88c37ed060de2c43fc18adfde3732256",
"assets/assets/audio/en-US/the_blackboard_is_behind_you.mp3": "3aaef9cd28be59945bded97b908161c8",
"assets/assets/audio/en-US/power_switch.mp3": "c33076b0aeadf6b83b22a8131546a395",
"assets/assets/audio/en-US/air_conditioner.mp3": "d7bc984ce0b88dcd418a2c7c92e54265",
"assets/assets/audio/en-US/i_ll_set_up_the_tripod_at_the_back.mp3": "5ff64113eb43e9336497f28182c763d5",
"assets/assets/audio/en-US/let_me_restart_the_connection.mp3": "88fdf861c66bf4f1a4eb4ca158dffe67",
"assets/assets/audio/en-US/memory_card.mp3": "5b25b2697e370ac080e324dc20e267d4",
"assets/assets/audio/en-US/it_worked_yesterday_but_not_today.mp3": "9c2b72e0f8a5293ff3d56d4a73031248",
"assets/assets/audio/en-US/your_username_is_your_staff_number.mp3": "61142537a7431d1fd93fea499ed990f2",
"assets/assets/audio/en-US/the_desks_can_be_rearranged.mp3": "3ba98b670a3aa26bbafa82d6a1777664",
"assets/assets/audio/en-US/microphone.mp3": "99a91704feabdb2085984406fc92523d",
"assets/assets/audio/en-US/the_memory_card_is_full.mp3": "908801b17d66ad760835d6995d3f4d5a",
"assets/assets/audio/en-US/let_me_switch_the_input_to_hdmi.mp3": "b5320a07cc82093170735e36a49fec75",
"assets/assets/audio/en-US/the_microphone_isn_t_working.mp3": "acd958ed02ee1ed33d83ca13b5ecee12",
"assets/assets/audio/en-US/sorry_for_the_inconvenience.mp3": "63630343147df9fa2f2087627427f2c8",
"assets/assets/audio/en-US/the_internet_is_very_slow_today.mp3": "c01ae183f3fcad6d7dc0285c7235e45b",
"assets/assets/audio/en-US/enjoy_your_class.mp3": "db8d322e1ba2e6398f5eb0b01f5305bd",
"assets/assets/audio/en-US/chair.mp3": "65451c4694d940e5769d0bb869c815f2",
"assets/assets/audio/en-US/audio_jack.mp3": "17085901a7170675c1e1c58c9999283e",
"assets/assets/audio/en-US/handheld_microphone.mp3": "d6120bd8634ed23e48856cc7ece1aaca",
"assets/assets/audio/en-US/press_record_five_minutes_before_class.mp3": "9620f22d1bf14fff9f53a6735595103f",
"assets/assets/audio/en-US/temperature.mp3": "ce7c4b7f93af785938e1c14a25125908",
"assets/assets/audio/en-US/classroom_computer.mp3": "b0a88af2ffb0aef16125a11b0a63eb32",
"assets/assets/audio/en-US/the_next_class_is_waiting_outside.mp3": "b872b58bf657f462b22b35efbe881e94",
"assets/assets/audio/en-US/surge_protector.mp3": "d674529ddf1a5cfde13f0a21a54adfc4",
"assets/assets/audio/en-US/resolution.mp3": "9ef86d525ecff6f38b64b2ee4a9c6c84",
"assets/assets/audio/en-US/keystone.mp3": "ceab9cd3f5d7f21b7ba95d3174181b2b",
"assets/assets/audio/en-US/light_switch.mp3": "5d6edb0401f998c86635c427e5ba4807",
"assets/assets/audio/en-US/door.mp3": "826e35a01e6d49ce2f805c5ea838ec3a",
"assets/assets/audio/en-US/vpn.mp3": "c971e7c31075ec45bc2ee1724b83c76e",
"assets/assets/audio/en-US/connection.mp3": "2404f70013c9d310a71f3e0eadaa31e5",
"assets/assets/audio/en-US/projection_screen.mp3": "c317a99e9629b2c32709155e99cbd0ff",
"assets/assets/audio/en-US/the_main_power_switch_is_by_the_door.mp3": "dd258c4136f78e47c01a905458f80b32",
"assets/assets/audio/en-US/press_the_power_button_on_the_control_panel.mp3": "92faf635b69a4ab0b51f10a1d17eb784",
"assets/assets/audio/en-US/can_i_write_on_the_screen.mp3": "2dadb6112d832231a57f6c19ea7f2e35",
"assets/assets/audio/en-US/the_batteries_are_dead_i_ll_replace_them.mp3": "baf8424ac29c5557b5e501e78a8b96b5",
"assets/assets/audio/en-US/could_you_dim_the_lights.mp3": "de481752740dfb8ba419eaa6c7292bb4",
"assets/assets/audio/en-US/the_password_is_on_the_card_on_the_wall.mp3": "766c6ef10ae220adabe0313aea2bb219",
"assets/assets/audio/en-US/broken.mp3": "71a9c29ca1a27aaefd9f7e07910c46d3",
"assets/assets/audio/en-US/we_can_move_you_to_a_spare_classroom.mp3": "5c803a34d78b8b7f5f0ae15ccb0c04da",
"assets/assets/audio/en-US/laser_pointer.mp3": "36f6765e30efa19af8af1633b7c36cf3",
"assets/assets/audio/en-US/the_lamp_needs_to_be_replaced.mp3": "0548b028e94be9493e23d87fa726d63f",
"assets/assets/audio/en-US/bandwidth.mp3": "bd1aacb13e6e4d9c92f6a73da8162ec8",
"assets/assets/audio/en-US/the_building_closes_at_ten_p_m.mp3": "6dc443bcfd7df00c2048709396efac65",
"assets/assets/audio/en-US/we_keep_spare_bulbs_in_the_drawer.mp3": "9d5cd7158a47dc8ee86ef2a7d2d53f60",
"assets/assets/audio/en-US/adapter.mp3": "46e627baada90e0250d63e03605499fe",
"assets/assets/audio/en-US/lapel_microphone.mp3": "9d3986dea56aab2192b6a532961856cd",
"assets/assets/audio/en-US/qr_code.mp3": "6d4da58fa5811fa1f1b464cb84b8fa0b",
"assets/assets/audio/en-US/please_use_this_microphone.mp3": "07e6d88569025f119386c3ac68f58a17",
"assets/assets/audio/en-US/there_s_no_sound.mp3": "b18c9e1f08720659fa78f2a77b0e541f",
"assets/assets/audio/en-US/recording.mp3": "a472df78e4f758b97cd862babd9fe0c7",
"assets/assets/audio/en-US/let_me_show_you_how_it_works.mp3": "3e93f4c1be7feda9fa01fd8c52350c35",
"assets/assets/audio/en-US/equipment_cabinet.mp3": "a838cf80f3710783e5b5e44a0827e03e",
"assets/assets/audio/en-US/copy_your_slides_to_the_usb_drive.mp3": "4bce1fe8e379aaad75cd4c1328259636",
"assets/assets/audio/en-US/it_will_be_repaired_tomorrow.mp3": "4e0c3d47517ba577569baf439a00899d",
"assets/assets/audio/en-US/there_are_spare_chairs_at_the_back.mp3": "33bc9d86acad86ec8c4390f29809c6ba",
"assets/assets/audio/en-US/scan_the_qr_code_to_sign_in.mp3": "376a4e6073649396ebb9a8f8d8ab8b99",
"assets/assets/audio/en-US/i_ll_bring_a_replacement_right_away.mp3": "179b65861a28d55d06113a035192fc3e",
"assets/assets/audio/en-US/the_lan_port_is_under_the_desk.mp3": "d759672dde3ad119e80d7d02f0602895",
"assets/assets/audio/en-US/i_ll_tape_the_cable_to_the_floor.mp3": "294c86af78571b5c2a9d2c0519f6da40",
"assets/assets/audio/en-US/technician.mp3": "8185f588dc18b85ea559c75e8dfbf6d7",
"assets/assets/audio/en-US/please_plug_in_the_hdmi_cable.mp3": "9cc9eb14f05e1e9be68443003abd9b54",
"assets/assets/audio/en-US/the_main_unit_is_locked_in_the_cabinet.mp3": "eca67db5892f52a1a8d7b8cb2f2fa710",
"assets/assets/audio/en-US/the_image_is_blurry.mp3": "1f0b9c70a701916ed338fc68ecf6e4dd",
"assets/assets/audio/en-US/camera.mp3": "ad26fb5aa89c33df08acc626a6e6ea24",
"assets/assets/audio/en-US/i_ll_check_it_before_your_next_class.mp3": "c5fda4c1d24c492574e08abf585e93a2",
"assets/assets/audio/en-US/static_noise.mp3": "cd9bc6a2e78b2220ca57e40d4fa1629e",
"assets/assets/audio/en-US/microphone_stand.mp3": "51d213b85d9f24d0b2d20e50ecb27786",
"assets/assets/audio/en-US/do_you_have_a_type_c_adapter.mp3": "f1ebd9c647bc94b2244975119d6bb4f7",
"assets/assets/audio/en-US/lectern.mp3": "87f36e25aba02502454f6fbbfe067df0",
"assets/assets/audio/en-US/click_share_screen_again.mp3": "b4d38fb2787310816e8d8b1bf6ac73d3",
"assets/assets/audio/en-US/let_me_check_if_it_s_muted.mp3": "b8dfef3eb30a614bb06fdce55d3edde1",
"assets/assets/audio/en-US/extension_cord.mp3": "f04b35fc5e61efeda779270e0ee21212",
"assets/assets/audio/en-US/control_panel.mp3": "93f5f84600efc9b0268bfaff6b9074ae",
"assets/assets/audio/en-US/the_screen_is_blank.mp3": "38d443aa1fda2687fd693fefad148e6a",
"assets/assets/audio/en-US/i_ll_call_the_technician_right_away.mp3": "9cb02bc7708d38d0e3e17eb89de5f348",
"assets/assets/audio/en-US/you_can_write_on_the_whiteboard.mp3": "cb43f741abeeee9a38ad455fe6cd466f",
"assets/assets/audio/en-US/where_can_i_print_my_handouts.mp3": "4a3f6bae224211ef7b580ad8d3e6fa74",
"assets/assets/audio/en-US/lighting.mp3": "d82d55a603f2882fd90d736c299d85fb",
"assets/assets/audio/en-US/out_of_order.mp3": "ce7d25363558760a59a7ad057a5e41b3",
"assets/assets/audio/en-US/the_projector_isn_t_working.mp3": "e7f75156255f81a00d91e6fa2ff1dd25",
"assets/assets/audio/en-US/do_you_need_anything_else.mp3": "bfaecadf472bedd84b3b577ad298c592",
"assets/assets/audio/en-US/i_can_t_connect_to_the_wi_fi.mp3": "70701f7e90a5fbcc8260d72de71a8abd",
"assets/assets/audio/en-US/ptz_camera.mp3": "d64206fd9bf395ca210c9ec8d987e450",
"assets/assets/audio/en-US/please_remain_calm.mp3": "fac5e412d6b769f01ee86a5f3f6d65fc",
"assets/assets/audio/en-US/i_hear_a_buzzing_sound.mp3": "7a06319e437df83e916783c9bedf708a",
"assets/assets/audio/en-US/please_plug_the_hdmi_cable_into_your_laptop.mp3": "f0ae79d7c42d5c2fd4ae97112164db4a",
"assets/assets/audio/en-US/you_can_use_the_classroom_computer.mp3": "e749569021405c81b53bc57fe8833dd8",
"assets/assets/audio/en-US/clock.mp3": "cdf96312ffa78f43a648c69608d10c5d",
"assets/assets/audio/en-US/speaker.mp3": "fb9ca0b1fd02985f380ce6b6dcb9cdfb",
"assets/assets/audio/en-US/it_s_a_hybrid_class_half_online.mp3": "33496c5c00c13ea7dcc3a6a5196ac2da",
"assets/assets/audio/en-US/wi_fi_password.mp3": "407116e39841222d62862d8f8e0e8bbf",
"assets/assets/audio/en-US/a_wired_connection_is_more_stable.mp3": "9c7c015a04e1b9ea7930a7511c10703f",
"assets/assets/audio/en-US/is_there_an_outlet_near_my_seat.mp3": "4124014d0a35465080c25a15c49a2df8",
"assets/assets/audio/en-US/i_ll_get_an_extension_cord_for_you.mp3": "da52dcefc6a7eda515b60f1a87372b6b",
"assets/assets/audio/en-US/everything_is_working_now.mp3": "832c56d738e87c3b0337845418ea3f06",
"assets/assets/audio/en-US/printer.mp3": "fae16818c4b78f85d3a799f3af26adac",
"assets/assets/audio/en-US/move_away_from_the_speakers_to_avoid_feedback.mp3": "225f6dc6e0dcbc5a820b9df08ab644b3",
"assets/assets/audio/en-US/photocopier.mp3": "5a1255b85e74661f81a5dd4f3055f8db",
"assets/assets/audio/en-US/projector_lamp.mp3": "e611a5002599466876d287749956db8b",
"assets/assets/audio/en-US/please_keep_the_back_door_closed.mp3": "2bbdb01c26b594149a04ea86ab7176d3",
"assets/assets/audio/en-US/tripod.mp3": "6c96429871110a11794b50bdf9012b2c",
"assets/assets/audio/en-US/do_you_have_a_usb_c_hub.mp3": "6da7ee11fac5b02d5c596bfe560023df",
"assets/assets/audio/en-US/amplifier.mp3": "7c99c05cba22132281d46c1329a2c6fa",
"assets/assets/audio/en-US/please_evacuate_the_building.mp3": "05eecd326bb71d8191186d9771ffbc4b",
"assets/assets/audio/en-US/please_mute_the_mic_during_the_break.mp3": "31245ec463a95da33e7c5954ac908dcd",
"assets/assets/audio/en-US/podium.mp3": "3979e472a09f23d49f3ec4462368f219",
"assets/assets/audio/en-US/do_i_need_the_vpn_to_open_this_site.mp3": "3a854e8aa36f90a5219a6a1dc6f99d8c",
"assets/assets/audio/en-US/can_you_lower_the_screen.mp3": "c91a323a7fe8f2d3d205e5df5777d9a9",
"assets/assets/audio/en-US/it_s_a_loose_connection_i_ll_re_plug_it.mp3": "75dc4effdfc2e70c688b6847cd5dc113",
"assets/assets/audio/en-US/you_can_write_on_the_whiteboard_here.mp3": "27538bc6e6dde0308f44f71a4a8bc3dc",
"assets/assets/audio/en-US/spare_classroom.mp3": "60e762411737bdbe2e4d6eec7ef8b221",
"assets/assets/audio/en-US/blinds.mp3": "04fdc9947d317acfb5113c8dbb21af35",
"assets/assets/audio/en-US/press_the_power_button_on_the_panel.mp3": "902d658e7e2fd05e6071d25023678d6c",
"assets/assets/audio/en-US/chalk.mp3": "9224f595c3af4305bdc679d00b216c74",
"assets/assets/audio/en-US/hybrid_class.mp3": "3796ab4beaa51025f4a6a94470652819",
"assets/assets/audio/en-US/it_s_not_working.mp3": "928f309c4bba2639fcd3de5fc68af3a6",
"assets/assets/audio/en-US/mute.mp3": "4f5b8983a2ba108b150dccead7d2cefb",
"assets/assets/audio/en-US/sure_the_room_will_be_darker.mp3": "7b4fec06ea6c8fd8f9d0ab6d55e77323",
"assets/assets/audio/en-US/these_markers_are_dried_out.mp3": "72e32a89711af22002a66394a9a0009b",
"assets/assets/audio/en-US/fire_extinguisher.mp3": "67efc8cd433d005d4fad38708088f3d1",
"assets/assets/audio/en-US/window.mp3": "c7f4b711871376f12ab64b764b70ee89",
"assets/assets/audio/en-US/power_outlet.mp3": "f7f51c723170e894f2181f08fda3ea5c",
"assets/assets/audio/en-US/yes_use_your_finger_or_the_pen.mp3": "79f28125922d4d441e7f789cde431d2a",
"assets/assets/audio/en-US/ventilation.mp3": "d5603d357fb4eccc981359d25f4f450e",
"assets/assets/audio/en-US/vga_adapter.mp3": "afd903b65592decd1d2ccd1aa1017722",
"assets/assets/audio/en-US/pull_the_blinds_down_please.mp3": "719a39f89e478d1253b3766cc42196ff",
"assets/assets/audio/en-US/overheating.mp3": "e36dd9a6781f33b02c7e2dda9e3704c2",
"assets/assets/audio/en-US/hdmi_cable.mp3": "50b3627e4c32cb8ef1cf21e17143c638",
"assets/assets/audio/en-US/login.mp3": "0e00257d3bfe3148a9707e05664ca6a4",
"assets/assets/audio/en-US/can_someone_help_me_with_the_equipment.mp3": "061ccf005d02ee90f723761556cd1e4c",
"assets/assets/audio/en-US/can_you_record_my_class.mp3": "5c34c8bc84ee250a10fe6e0e23957cbd",
"assets/assets/audio/en-US/thermostat.mp3": "4eabd56b1b88bb6009f044394a515f57",
"assets/assets/audio/en-US/here_is_a_laser_pointer_for_you.mp3": "9e7ced038344d016b3f07fc1e7136489",
"assets/assets/audio/en-US/you_need_this_adapter_for_your_old_laptop.mp3": "1f84513aaa02349d1c2e689c27620587",
"assets/assets/audio/en-US/the_ptz_camera_follows_the_teacher.mp3": "3deac5efda67521e245064c8a235a8d9",
"assets/assets/audio/en-US/projector.mp3": "55b93c1457030b07e831582e6f3a5253",
"assets/assets/audio/en-US/desk.mp3": "6386f05255b2c8c4f09bd254579a637b",
"assets/assets/audio/en-US/the_fire_extinguisher_is_by_the_exit.mp3": "64ce4d56161306163bf009e310fe6718",
"assets/assets/audio/en-US/live_streaming.mp3": "fb45b7c79d0c211535d94123a83ffa10",
"assets/assets/audio/en-US/the_thermostat_is_set_to_24_degrees.mp3": "681db86ea7662365701a496ff429b7f4",
"assets/assets/audio/en-US/power_outage.mp3": "8dc1b582dfd5aec2db2e35b3f2ab3f95",
"assets/assets/audio/en-US/lan_port.mp3": "af029272384db0eb0c15cefc1290dde6",
"assets/assets/audio/en-US/please_turn_off_the_equipment_after_class.mp3": "6cd7800b8beccad2562bf81bb19646fc",
"assets/assets/audio/en-US/wireless_microphone.mp3": "be04d54eed6d9fb4a389fb9af64a7b14",
"assets/assets/audio/en-US/video_conference.mp3": "8d96a8b793e5a1ee7b76ce1c74c36a83",
"assets/assets/audio/en-US/username.mp3": "ffef19b750d2cd7c325a2dd4433fc9c4",
"assets/assets/audio/en-US/blank_screen.mp3": "a702d831be5a7f87991225625a11fc98",
"assets/assets/audio/en-US/it_s_stuffy_in_here.mp3": "e2f094a3d865475b1f2e85f79c301abe",
"assets/assets/audio/en-US/wi_fi.mp3": "70a39b39dce61b53d6cc4f5281113b6a",
"assets/assets/audio/en-US/water_dispenser.mp3": "e882ff6b5f9f17c62900ad26fcc85a2e",
"assets/assets/audio/en-US/speak_a_little_louder_please.mp3": "c6b8c5ec781fccb912014d4187f60b1e",
"assets/assets/audio/en-US/tape.mp3": "9f591ca3e5420f48a2b465527a110fa6",
"assets/assets/audio/en-US/let_me_know_if_you_need_any_help.mp3": "9f27ef693c9e60d4b7736e5a02e118ac",
"assets/assets/audio/en-US/can_we_close_the_curtains.mp3": "6cf639f6962703cfdb3e6f3a93dba377",
"assets/assets/audio/en-US/i_ll_call_campus_security.mp3": "e4511da2c8e49ce06fb3ca1d246750d3",
"assets/assets/audio/en-US/replacement.mp3": "81783f411bdb046aacd74d0f0257c9e3",
"assets/assets/audio/en-US/i_ll_turn_the_air_conditioner_down.mp3": "9bfc9889bf223fd4b482ff07ba915f45",
"assets/assets/audio/en-US/the_photocopier_is_in_the_office.mp3": "73b14fb272e5f85adb3fc6c25ef0dacc",
"assets/assets/audio/en-US/frozen.mp3": "46a9845b725cf441011d3131a90ed3ea",
"assets/assets/audio/en-US/this_room_is_booked_until_ten.mp3": "c7cad0cfb3bc397fa33b688fee49a0a3",
"assets/assets/audio/en-US/let_me_check_the_power_switch.mp3": "7e54ee40970822e5eaf613f2d65ea6e9",
"assets/assets/audio/en-US/sound_system.mp3": "06cd111afff3753cbd7cfe00e43ed2c3",
"assets/assets/audio/en-US/screen_sharing.mp3": "eb43c08ae70e558ffdf0a150bb350e8d",
"assets/assets/audio/en-US/my_laptop_can_t_detect_the_hdmi.mp3": "8ac44fcfc06d66f73a98eb42dd32af1d",
"assets/assets/audio/en-US/it_s_too_cold_in_here.mp3": "0a9b67ee9e83b707c78da3bbdcf11d98",
"assets/assets/audio/en-US/will_the_class_be_streamed_online.mp3": "4fd7add42e281989a8de1a9b6fa90c1d",
"assets/assets/audio/en-US/usb_flash_drive.mp3": "746f1152ecc898c4a1e8965744f60a39",
"assets/assets/audio/en-US/can_i_have_a_handheld_mic.mp3": "b577f70a867bf196fdab18ccb692da31",
"assets/assets/audio/en-US/i_can_t_log_in_to_the_computer.mp3": "3ab544d7c31bcf8afb2cbb0d568d6b74",
"assets/assets/audio/en-US/this_room_is_out_of_order_today.mp3": "2505aab28f2b52bf2799b224a94e6a26",
"assets/assets/audio/en-US/wait_a_moment_i_ll_restart_it.mp3": "04bd54bb16f28617bfeb962bbddf00af",
"assets/assets/audio/en-US/something_is_broken.mp3": "3919f205a4841c424e9e51bb46518b1c",
"assets/assets/audio/en-US/do_you_have_a_stapler.mp3": "1b5aff58ebebfea74fdc162338be2493",
"assets/assets/audio/en-US/i_ll_fix_the_keystone_so_it_s_not_slanted.mp3": "c5a975c0cd376352e20c99ea55f6803e",
"assets/assets/audio/en-US/where_is_the_chalk.mp3": "6e7e9a475d2073c533b166f92cf0dae4",
"assets/assets/audio/en-US/interactive_flat_panel.mp3": "8418df4f1886051c13f883c2d19608c1",
"assets/assets/audio/en-US/i_ll_restart_it_wait_a_moment.mp3": "92e5ca698023e567882d90d55d6daafc",
"assets/assets/audio/en-US/switch_the_input_to_hdmi_1.mp3": "f4edefca657f5313a5e23eee018a9ab9",
"assets/assets/audio/en-US/battery.mp3": "bf8bc647d1858c6bae23debe785fba93",
"assets/assets/audio/en-US/the_whole_sound_system_was_upgraded.mp3": "531c3e7d9e741408911f79fc83871169",
"assets/assets/audio/en-US/the_computer_is_frozen.mp3": "03cfe0c5aa8e852bca4d9f5b2aec2cf5",
"assets/assets/audio/en-US/loose_connection.mp3": "2256056649670a2fc5e9424974da1207",
"assets/assets/audio/en-US/can_t_they_see_my_screen.mp3": "b94a0b6e131d8b2be7a3aa8e40c689bf",
"assets/assets/audio/en-US/there_s_a_power_outage_class_is_cancelled.mp3": "6c32e58a326b7c9561f8a74d9d661495",
"assets/assets/audio/en-US/feedback.mp3": "8d10c633ef24556d8b681488f25b5a58",
"assets/assets/audio/en-US/curtain.mp3": "cd451076a96f6dd43c6e7428466c50d5",
"assets/assets/audio/en-US/please_sign_the_attendance_sheet.mp3": "bf42ba26cee61fe45d248bec98acdf97",
"assets/assets/audio/en-US/whiteboard_marker.mp3": "fd97b9114dcf8731ceb6146240adf2e7",
"assets/assets/audio/en-US/press_screen_down_on_the_panel.mp3": "c0f153a27e01d553bf5487ce424390ea",
"assets/assets/audio/en-US/network_cable.mp3": "40585b8e3e5742c447c5dee493182ad1",
"assets/assets/audio/en-US/the_remote_control_doesn_t_respond.mp3": "abb883ab5e69e8e7a936417a461760d6",
"assets/assets/audio/en-US/my_laptop_doesn_t_detect_the_hdmi.mp3": "cdc12620e36c2f7967c264bd3f9a40dd",
"assets/assets/audio/en-US/can_we_open_a_window.mp3": "74be2c7a18b2ceee3dfc2f08326e95b1",
"assets/assets/audio/en-US/the_clock_is_five_minutes_fast.mp3": "6bb5e8910da19be63ce705f102be2cee",
"assets/assets/audio/en-US/adjust_the_height_here.mp3": "28a7b7473ec482734c673f4928dba4f7",
"assets/assets/audio/en-US/the_light_switch_is_next_to_the_door.mp3": "89f1d7521bd37984a5210e04831e3084",
"assets/assets/audio/en-US/wireless_presenter.mp3": "eec5d1059ea46d2f9ff1636c180b16ea",
"assets/assets/audio/en-US/the_amplifier_is_in_the_cabinet.mp3": "88c7c55440103d8914258141bf130a54",
"assets/assets/audio/en-US/the_projector_won_t_turn_on.mp3": "2079e2e671fcf537f627be93f470e550",
"assets/assets/audio/en-US/set_the_resolution_to_1920_by_1080.mp3": "694a14789ce71a83380dd35b7eb3d436",
"assets/assets/audio/en-US/repair.mp3": "968d078eadd7d04614b328d510a5e977",
"assets/assets/audio/en-US/the_microphone_keeps_cutting_out.mp3": "5edd1366f05d74e5f2fee4113ca2ff44",
"assets/assets/audio/en-US/not_working.mp3": "c9640bbadf3a4c0189c446a9ad81273c",
"assets/assets/audio/en-US/the_equipment_is_under_maintenance.mp3": "797783d7fdd4043a9f81bdd49bd51baa",
"assets/assets/audio/en-US/use_this_clicker_to_change_slides.mp3": "15a621d500cfdcf70b3a9f4506ab02d6",
"assets/assets/audio/en-US/is_the_temperature_ok_for_you.mp3": "8afe135e3b653c88bbd579ec0fac33e1",
"assets/assets/audio/en-US/spare_bulb.mp3": "b7423effaa6a31ee25e92630f60023d6",
"assets/assets/audio/en-US/it_s_too_bright_in_here.mp3": "bacf20a6caff267db698f43913a9845e",
"assets/assets/audio/en-US/maintenance.mp3": "d39ff1bb04dcd280174d29a17b47e46f",
"assets/assets/audio/en-US/the_fire_exit_is_over_there.mp3": "f3b90bb1ed19e2f001ed52cd7ed6ea49",
"assets/assets/audio/en-US/turn_the_volume_up_a_little.mp3": "ef378c29aabfcda134c9639ea82f61f0",
"assets/assets/audio/en-US/attendance_sheet.mp3": "42d353a178e5458438e4103e1392cd54",
"assets/assets/audio/en-US/it_s_too_dark_in_here.mp3": "7e7e3c663ba18ec5c8596cf7ac95a3b0",
"assets/assets/audio/en-GB/remote_control.mp3": "18292813b0e100737f4aa96db5840733",
"assets/assets/audio/en-GB/i_ll_change_the_batteries.mp3": "d88fa2d3ef8b965e3b14ed52032794e9",
"assets/assets/audio/en-GB/usb_c_hub.mp3": "363496e3136e4ff0a7b26172ef005a0d",
"assets/assets/audio/en-GB/stapler.mp3": "f4eeac5c3db24d98e540a2ecde36fbd0",
"assets/assets/audio/en-GB/all_equipment_uses_a_surge_protector.mp3": "51fce387e19645c1426a93a48c0f0d06",
"assets/assets/audio/en-GB/we_use_tencent_meeting_for_online_students.mp3": "969a48d35d828ab980f3fd44b1943b3b",
"assets/assets/audio/en-GB/the_wi_fi_password_is_on_the_podium.mp3": "29cf703628258fa3c37dcbd694b395e8",
"assets/assets/audio/en-GB/class_starts_at_eight.mp3": "d5518f65d21d028f1095d98ecee6c183",
"assets/assets/audio/en-GB/please_keep_the_wireless_mic_with_you.mp3": "35d080503da2d6711e626518c602bbd9",
"assets/assets/audio/en-GB/clip_the_lapel_mic_to_your_collar.mp3": "dbb89694bcb7e5cb72b338e260970703",
"assets/assets/audio/en-GB/whiteboard.mp3": "b87f00e3a108de9da9f3ca4d40860563",
"assets/assets/audio/en-GB/the_projector_overheated_let_it_cool_down.mp3": "0132cf982fa818d5409a349679469668",
"assets/assets/audio/en-GB/plug_it_into_the_audio_jack_here.mp3": "5da2cf8631de2b217378b7461dbd4f3e",
"assets/assets/audio/en-GB/there_s_a_power_outage_in_this_building.mp3": "723f07af3f913ad65c6494ccbd09ffa9",
"assets/assets/audio/en-GB/there_s_no_sound_from_the_speakers.mp3": "23e72e6cc47a17601e9a437d339fe268",
"assets/assets/audio/en-GB/the_eraser_is_on_the_tray.mp3": "945bbc9c101326a3a1a1d3960a6773aa",
"assets/assets/audio/en-GB/eraser.mp3": "98ffe3763ef3851d30778b039f522e41",
"assets/assets/audio/en-GB/is_there_a_lectern.mp3": "7d884fc502fee226eba5c3de51c7125b",
"assets/assets/audio/en-GB/laptop.mp3": "225495528beee8a56b662317a9ff7e30",
"assets/assets/audio/en-GB/the_water_dispenser_is_in_the_hallway.mp3": "959f3fcbd9e7fbbf01b378e02be27be9",
"assets/assets/audio/en-GB/there_s_a_high_pitched_noise.mp3": "e69a76c5619ad6c84675c58bb806bcd2",
"assets/assets/audio/en-GB/volume.mp3": "2148fa25242f0cc51d160295d698ebf9",
"assets/assets/audio/en-GB/blackboard.mp3": "a17049535cbfea2d2da7b7bdbe564c9c",
"assets/assets/audio/en-GB/the_blackboard_is_behind_you.mp3": "8f88b3ed96f81d9bb63984c15dfa8b41",
"assets/assets/audio/en-GB/power_switch.mp3": "03600bf486331903c254900c6b47bd41",
"assets/assets/audio/en-GB/air_conditioner.mp3": "51f868ce3f74b1110ad46f7b61411aeb",
"assets/assets/audio/en-GB/i_ll_set_up_the_tripod_at_the_back.mp3": "5002fe3a653b1e97cf1a7cdffff4ee85",
"assets/assets/audio/en-GB/let_me_restart_the_connection.mp3": "8d96ec3405bc22eb942b37085a9bdde1",
"assets/assets/audio/en-GB/memory_card.mp3": "0b3c5ecc61db9a32c488428d13c58d81",
"assets/assets/audio/en-GB/it_worked_yesterday_but_not_today.mp3": "aebf07bdd5f5bc95b9274ae6b1f99d65",
"assets/assets/audio/en-GB/your_username_is_your_staff_number.mp3": "a8a1e84c9970d5be3cbb6895e31942d3",
"assets/assets/audio/en-GB/the_desks_can_be_rearranged.mp3": "c1ccb97f63ab9233f8392d26828cdcbb",
"assets/assets/audio/en-GB/microphone.mp3": "19093f6c062393c081ad4752c010b151",
"assets/assets/audio/en-GB/the_memory_card_is_full.mp3": "71a228a09eb3833f0ae60a51435ab2b4",
"assets/assets/audio/en-GB/let_me_switch_the_input_to_hdmi.mp3": "a57d939ccd9a9d6afddd835bc7af6826",
"assets/assets/audio/en-GB/the_microphone_isn_t_working.mp3": "04fa7ac4b5e9569cd9894206f3c04036",
"assets/assets/audio/en-GB/sorry_for_the_inconvenience.mp3": "92e75c5792b903dae262d375537f7a96",
"assets/assets/audio/en-GB/the_internet_is_very_slow_today.mp3": "5690f99b7e8674d162c1323f1bc6790d",
"assets/assets/audio/en-GB/enjoy_your_class.mp3": "88f0cebc0255866b39bb31027088290f",
"assets/assets/audio/en-GB/chair.mp3": "66f6254661473b7ac678af2d24d3fe0b",
"assets/assets/audio/en-GB/audio_jack.mp3": "6a799ec69ddaea5bbced4d035c9bb811",
"assets/assets/audio/en-GB/handheld_microphone.mp3": "ec075b71bda019a9412508c5f4824ac0",
"assets/assets/audio/en-GB/press_record_five_minutes_before_class.mp3": "8f5b7ce859886b9c6ae9292e5bb8975b",
"assets/assets/audio/en-GB/temperature.mp3": "163e5dd00210cdf675a175cf18491665",
"assets/assets/audio/en-GB/classroom_computer.mp3": "3acba63bd0b3d8eb7752c26bb58d5566",
"assets/assets/audio/en-GB/the_next_class_is_waiting_outside.mp3": "d15f088bed3a7e642a7eed63dffc76ce",
"assets/assets/audio/en-GB/surge_protector.mp3": "96557d93ccfeeee710621c1ae6cb1790",
"assets/assets/audio/en-GB/resolution.mp3": "d18a26711563f21df783e58ab6ff424d",
"assets/assets/audio/en-GB/keystone.mp3": "e1dca22a7fc62172905c8884938773a0",
"assets/assets/audio/en-GB/light_switch.mp3": "6d97404528c1be5f435b8ed0fb51aca1",
"assets/assets/audio/en-GB/door.mp3": "f38b775c8110ed2051789018cc2602d3",
"assets/assets/audio/en-GB/vpn.mp3": "8ddcc459a4e4c2b2a9851458a67cb099",
"assets/assets/audio/en-GB/connection.mp3": "8fe414b6bbe8832f9f75f01b4645ae08",
"assets/assets/audio/en-GB/projection_screen.mp3": "2f0d5706002ca9eb5267429c9a1e9de6",
"assets/assets/audio/en-GB/the_main_power_switch_is_by_the_door.mp3": "d6437b98facd99772bbb582d5baab117",
"assets/assets/audio/en-GB/press_the_power_button_on_the_control_panel.mp3": "2f2983efb683ab7b325ca1b073ab30ba",
"assets/assets/audio/en-GB/can_i_write_on_the_screen.mp3": "a745263199a2aceec912a4f9068802e7",
"assets/assets/audio/en-GB/the_batteries_are_dead_i_ll_replace_them.mp3": "64ac4c0ef2d024d6b27461849321f9cb",
"assets/assets/audio/en-GB/could_you_dim_the_lights.mp3": "96a2206d8a6fe27266e922514ad4924c",
"assets/assets/audio/en-GB/the_password_is_on_the_card_on_the_wall.mp3": "54b1c2d1ffefb975e09f67f7fc0bac62",
"assets/assets/audio/en-GB/broken.mp3": "b6ca40748ab0a80d03a91713fc9af7eb",
"assets/assets/audio/en-GB/we_can_move_you_to_a_spare_classroom.mp3": "af5e223e2b544ec84bc8a5bff1e6e1b0",
"assets/assets/audio/en-GB/laser_pointer.mp3": "3b5af4587211b7ba911e0b08a2c82ce7",
"assets/assets/audio/en-GB/the_lamp_needs_to_be_replaced.mp3": "063ea4919ddc38afaae6f7e2ecdd4ec6",
"assets/assets/audio/en-GB/bandwidth.mp3": "91211d97e4259fbb312288397426eee3",
"assets/assets/audio/en-GB/the_building_closes_at_ten_p_m.mp3": "ca9c94f206c17a59789b78366fa7aa81",
"assets/assets/audio/en-GB/we_keep_spare_bulbs_in_the_drawer.mp3": "789b4aada1af98887100ed98881a6193",
"assets/assets/audio/en-GB/adapter.mp3": "5b47bc3ee3798607afae4b76f66de064",
"assets/assets/audio/en-GB/lapel_microphone.mp3": "cf41ecdc4ddb13d9040bdab00371910b",
"assets/assets/audio/en-GB/qr_code.mp3": "a3ec166fa08029408017b711e9af5c11",
"assets/assets/audio/en-GB/please_use_this_microphone.mp3": "40ac4f653471a059cc4a9e22c8a15ed4",
"assets/assets/audio/en-GB/there_s_no_sound.mp3": "fc66ca5e3a3449356c0553dbb8c3c0c3",
"assets/assets/audio/en-GB/recording.mp3": "4a07a904229e4114899ed60f2dfa3dbb",
"assets/assets/audio/en-GB/let_me_show_you_how_it_works.mp3": "2e7093dddd8ed6871a20b19b5f028568",
"assets/assets/audio/en-GB/equipment_cabinet.mp3": "bbe2edc80f0f5f09c570a388da94d0df",
"assets/assets/audio/en-GB/copy_your_slides_to_the_usb_drive.mp3": "3d9074a023c18d0fd2e6f79880486b9f",
"assets/assets/audio/en-GB/it_will_be_repaired_tomorrow.mp3": "a9da84060fdd3d4aefef60423aa77342",
"assets/assets/audio/en-GB/there_are_spare_chairs_at_the_back.mp3": "da85ba04cd2363c166509ecb812cf687",
"assets/assets/audio/en-GB/scan_the_qr_code_to_sign_in.mp3": "86439fc0d39a3abe9b037246fb68a78a",
"assets/assets/audio/en-GB/i_ll_bring_a_replacement_right_away.mp3": "0fe79ef0430163f085c0582397772546",
"assets/assets/audio/en-GB/the_lan_port_is_under_the_desk.mp3": "5b4f3d8cbb6d2c2f601a09654ab10d10",
"assets/assets/audio/en-GB/i_ll_tape_the_cable_to_the_floor.mp3": "4067bb793470bd26079ce2f4eadadf17",
"assets/assets/audio/en-GB/technician.mp3": "28aa94182450a58e9d3497f3d3d42cc2",
"assets/assets/audio/en-GB/please_plug_in_the_hdmi_cable.mp3": "c59b2160f0f9c721d9a5645ec2618210",
"assets/assets/audio/en-GB/the_main_unit_is_locked_in_the_cabinet.mp3": "7cfa12bd5c0bc2daba5cdbe4ccc77bb9",
"assets/assets/audio/en-GB/the_image_is_blurry.mp3": "805041ffe6ff43bfb41208097096f177",
"assets/assets/audio/en-GB/camera.mp3": "5c8df84ac08bccb0eb24a46bfe501f2a",
"assets/assets/audio/en-GB/i_ll_check_it_before_your_next_class.mp3": "2bf0c9d9efa5d4d699d8d6ac438c939f",
"assets/assets/audio/en-GB/static_noise.mp3": "bfc4b67ddf9bebd8f38601fae38d9ad1",
"assets/assets/audio/en-GB/microphone_stand.mp3": "4ea00eccbea50f6e460955f9d02a8785",
"assets/assets/audio/en-GB/do_you_have_a_type_c_adapter.mp3": "4f12f236dd38c6168dfd86d1047e791a",
"assets/assets/audio/en-GB/lectern.mp3": "fafb9abdaecc40af174d165f1ed49319",
"assets/assets/audio/en-GB/click_share_screen_again.mp3": "06bf1236e5dfb2baefd4887e4f34072e",
"assets/assets/audio/en-GB/let_me_check_if_it_s_muted.mp3": "2bdf6e6a5efdb432a77eae2be9940ebb",
"assets/assets/audio/en-GB/extension_cord.mp3": "cc3cedc5d90bbdbe9ba6907301695512",
"assets/assets/audio/en-GB/control_panel.mp3": "8f0c2867cad3d7fcd7bbfea4579c7a76",
"assets/assets/audio/en-GB/the_screen_is_blank.mp3": "1f3d3968c755da8d5e6f7d8cb2031c42",
"assets/assets/audio/en-GB/i_ll_call_the_technician_right_away.mp3": "1525861e7d6a5f1b248cb177321c0a73",
"assets/assets/audio/en-GB/you_can_write_on_the_whiteboard.mp3": "50469b193f758d43f9739fc56e423f89",
"assets/assets/audio/en-GB/where_can_i_print_my_handouts.mp3": "715df3bfb88ee0c4806590b49b67f7b5",
"assets/assets/audio/en-GB/lighting.mp3": "cd21313bfc7af93eae4b3d8b6e751561",
"assets/assets/audio/en-GB/out_of_order.mp3": "7ae25b75ab8847db25da5822e04022aa",
"assets/assets/audio/en-GB/the_projector_isn_t_working.mp3": "31ccefc98739057a436667a1231d6680",
"assets/assets/audio/en-GB/do_you_need_anything_else.mp3": "a41fc15ab078f0e791361bdf6ae7a36e",
"assets/assets/audio/en-GB/i_can_t_connect_to_the_wi_fi.mp3": "76af89b193d9f2bfee9be504fe62f89c",
"assets/assets/audio/en-GB/ptz_camera.mp3": "fc21c0c14bf509410fbcff0ab40bcee2",
"assets/assets/audio/en-GB/please_remain_calm.mp3": "c4ab5e6196e4956c4269e01091e84a6f",
"assets/assets/audio/en-GB/i_hear_a_buzzing_sound.mp3": "a5b5f250b7a19b3cbdd92b77a32840a9",
"assets/assets/audio/en-GB/please_plug_the_hdmi_cable_into_your_laptop.mp3": "c5b81320e7d3276483ea974b88d2ad7b",
"assets/assets/audio/en-GB/you_can_use_the_classroom_computer.mp3": "c7ae4b20ffb855860f3b63a318a53e8c",
"assets/assets/audio/en-GB/clock.mp3": "0a22f69d9bd22224af74daaed17ceb60",
"assets/assets/audio/en-GB/speaker.mp3": "755c812ff132c8d226c488e5c23bd76e",
"assets/assets/audio/en-GB/it_s_a_hybrid_class_half_online.mp3": "3a054d3aeba004fab48732dfff811559",
"assets/assets/audio/en-GB/wi_fi_password.mp3": "59ea7e49d062b0e2032125bb416eb536",
"assets/assets/audio/en-GB/a_wired_connection_is_more_stable.mp3": "2bd0b16d4d902742845ca7da6255b0d8",
"assets/assets/audio/en-GB/is_there_an_outlet_near_my_seat.mp3": "99e114ee695aaed083a13ea6b068c02a",
"assets/assets/audio/en-GB/i_ll_get_an_extension_cord_for_you.mp3": "1c96b3366375715fe281dee4bf956825",
"assets/assets/audio/en-GB/everything_is_working_now.mp3": "c0d0b709600be02791268ef52ce5727a",
"assets/assets/audio/en-GB/printer.mp3": "55ed2efc6f6aff0fac6f8768a626e8a2",
"assets/assets/audio/en-GB/move_away_from_the_speakers_to_avoid_feedback.mp3": "28baa0d1612a93cdbbb6da3658fe7625",
"assets/assets/audio/en-GB/photocopier.mp3": "706cbe0b88dad51a441d22106d9e5da0",
"assets/assets/audio/en-GB/projector_lamp.mp3": "f35fcae50a28786c3fb4a066d3bd93e9",
"assets/assets/audio/en-GB/please_keep_the_back_door_closed.mp3": "105d3a944f5bc5dc8c48145d233fc709",
"assets/assets/audio/en-GB/tripod.mp3": "0045f4040983841cbf761a4264cc238c",
"assets/assets/audio/en-GB/do_you_have_a_usb_c_hub.mp3": "e70289af490a57d9ae484a7eaf9b3303",
"assets/assets/audio/en-GB/amplifier.mp3": "a2ed8ad719797a48ee788cf051736314",
"assets/assets/audio/en-GB/please_evacuate_the_building.mp3": "326343b666c14096800df624827d726b",
"assets/assets/audio/en-GB/please_mute_the_mic_during_the_break.mp3": "8d903cb0b6770abd4ed7eb54a15311ff",
"assets/assets/audio/en-GB/podium.mp3": "695a70fe32c5f9878ac3c725f0269d65",
"assets/assets/audio/en-GB/do_i_need_the_vpn_to_open_this_site.mp3": "6613bbfc2f28fd9b0fe5f4ea92d0aa27",
"assets/assets/audio/en-GB/can_you_lower_the_screen.mp3": "eb33e4097aa47dac256e017cbec275a6",
"assets/assets/audio/en-GB/it_s_a_loose_connection_i_ll_re_plug_it.mp3": "45ef8e65bf35246595ae97661214c675",
"assets/assets/audio/en-GB/you_can_write_on_the_whiteboard_here.mp3": "de196b6f76abca69ac781eceb2531a86",
"assets/assets/audio/en-GB/spare_classroom.mp3": "f6fe0c1ac1293ac3b1a1d1c9e52693d0",
"assets/assets/audio/en-GB/blinds.mp3": "c718b3709d755893df5b32cd9a61f862",
"assets/assets/audio/en-GB/press_the_power_button_on_the_panel.mp3": "958071bbe4b506ac0105c65b172b6fa8",
"assets/assets/audio/en-GB/chalk.mp3": "b8a40510076325e0c0238755b7c3b968",
"assets/assets/audio/en-GB/hybrid_class.mp3": "828b0cd7a4d47fafd97ff881680bdabe",
"assets/assets/audio/en-GB/it_s_not_working.mp3": "7a3d6ee7ced890fab9e0a4e1452ad4c3",
"assets/assets/audio/en-GB/mute.mp3": "5bd6bc3751543056f86a401364c6b5fe",
"assets/assets/audio/en-GB/sure_the_room_will_be_darker.mp3": "fdcc8a206dd7ceaab8f69ed731cd1015",
"assets/assets/audio/en-GB/these_markers_are_dried_out.mp3": "945543932dd2181b104787f400f01f34",
"assets/assets/audio/en-GB/fire_extinguisher.mp3": "bb9de0693b83c6534e16fbfb052bfbc6",
"assets/assets/audio/en-GB/window.mp3": "36c00c1508378481c3fb6d6d41c3d75f",
"assets/assets/audio/en-GB/power_outlet.mp3": "d680ec66fefb3228ff1af5ad898907a2",
"assets/assets/audio/en-GB/yes_use_your_finger_or_the_pen.mp3": "61f2ca3f8394bbaca669be78b9f4299e",
"assets/assets/audio/en-GB/ventilation.mp3": "d8d43271974b8678d11b53bb3a4fd553",
"assets/assets/audio/en-GB/vga_adapter.mp3": "dccf97d8cdbfae79d4c5a3cc6d9056b3",
"assets/assets/audio/en-GB/pull_the_blinds_down_please.mp3": "0efbca1f68c1d2fa2caffcd783c15f0d",
"assets/assets/audio/en-GB/overheating.mp3": "b6c930afa8324a8266d118831c1ee51a",
"assets/assets/audio/en-GB/hdmi_cable.mp3": "71e74114f944b98882925c4c22025656",
"assets/assets/audio/en-GB/login.mp3": "27ff41971a70e2902229a39b242383a1",
"assets/assets/audio/en-GB/can_someone_help_me_with_the_equipment.mp3": "43af4de9b035905378a530ba0f4dc2d6",
"assets/assets/audio/en-GB/can_you_record_my_class.mp3": "fea55bdb854be413d1a9e004d7396963",
"assets/assets/audio/en-GB/thermostat.mp3": "21d76274120c4f97b8b65c94c58ddf5a",
"assets/assets/audio/en-GB/here_is_a_laser_pointer_for_you.mp3": "28ae3ebf446943370037e870a32f5a5f",
"assets/assets/audio/en-GB/you_need_this_adapter_for_your_old_laptop.mp3": "9ef748a8df275730650dc10c74c75b33",
"assets/assets/audio/en-GB/the_ptz_camera_follows_the_teacher.mp3": "27e56a7da76a6c3edb5ce044d44db24a",
"assets/assets/audio/en-GB/projector.mp3": "da0023adaf5f0739b060b37a25164adc",
"assets/assets/audio/en-GB/desk.mp3": "315ea1641a8c3ac18f6574f0742c3676",
"assets/assets/audio/en-GB/the_fire_extinguisher_is_by_the_exit.mp3": "2b23a45fa0f4e61002f0509378448196",
"assets/assets/audio/en-GB/live_streaming.mp3": "f18546adc2f7b9080ebd4f7cc881a637",
"assets/assets/audio/en-GB/the_thermostat_is_set_to_24_degrees.mp3": "d6386179d7113ba05996d0f9c788cb43",
"assets/assets/audio/en-GB/power_outage.mp3": "85344b1da9e7cc089ed95c3921d2676c",
"assets/assets/audio/en-GB/lan_port.mp3": "92ab6edfdf3bc61b4e2eed067b7bcdf6",
"assets/assets/audio/en-GB/please_turn_off_the_equipment_after_class.mp3": "499f89e13b57dd8b70df76d84b36eafc",
"assets/assets/audio/en-GB/wireless_microphone.mp3": "f8c5c47f638070a54108705b291c3022",
"assets/assets/audio/en-GB/video_conference.mp3": "a5d227b6179adaeadca50ac2bf6bbabd",
"assets/assets/audio/en-GB/username.mp3": "e42bca8d0467919d8dee9ea623c0b196",
"assets/assets/audio/en-GB/blank_screen.mp3": "ddd9afd0c07cf3917e18d2df060afd68",
"assets/assets/audio/en-GB/it_s_stuffy_in_here.mp3": "80bcb659c2286bca3176512fa9ed8d37",
"assets/assets/audio/en-GB/wi_fi.mp3": "e3b3eea1cef9ff1d82ac0a392fca537a",
"assets/assets/audio/en-GB/water_dispenser.mp3": "6be3cf0db04e7fe7ef6e735f0a1ccf5e",
"assets/assets/audio/en-GB/speak_a_little_louder_please.mp3": "8b4b3b2600f50103189e496a0b8f1a60",
"assets/assets/audio/en-GB/tape.mp3": "0bdfb22378b8a44de21b4d308fcc7411",
"assets/assets/audio/en-GB/let_me_know_if_you_need_any_help.mp3": "9c2ae1c31976bc62d2cbe62ba95edaac",
"assets/assets/audio/en-GB/can_we_close_the_curtains.mp3": "d3626ca3edefc792e462273baa8c3a7a",
"assets/assets/audio/en-GB/i_ll_call_campus_security.mp3": "ff5c563a5b5f6b94a75ce5a67156243e",
"assets/assets/audio/en-GB/replacement.mp3": "83c32d0d24faa5143f1e5885f61e4ac6",
"assets/assets/audio/en-GB/i_ll_turn_the_air_conditioner_down.mp3": "7236cfb9ccaaf35aa1cb38509ae8a7f3",
"assets/assets/audio/en-GB/the_photocopier_is_in_the_office.mp3": "929cf21c538f0e371d880a9981db6705",
"assets/assets/audio/en-GB/frozen.mp3": "e7aac00d94e58717cb4dda9b0fbb82f6",
"assets/assets/audio/en-GB/this_room_is_booked_until_ten.mp3": "9e126f7b4eea8683deb61e7da51d937a",
"assets/assets/audio/en-GB/let_me_check_the_power_switch.mp3": "8b702ed040a9919bae5a30d24092ab04",
"assets/assets/audio/en-GB/sound_system.mp3": "7311f8ce15e077000af15c8628685dd3",
"assets/assets/audio/en-GB/screen_sharing.mp3": "961b0dc33165779ff0fd812054a4514b",
"assets/assets/audio/en-GB/my_laptop_can_t_detect_the_hdmi.mp3": "80a54a763785b1d3fc4df602fc2a6c34",
"assets/assets/audio/en-GB/it_s_too_cold_in_here.mp3": "d91bc5e19afa3254a31b1f9acd32628e",
"assets/assets/audio/en-GB/will_the_class_be_streamed_online.mp3": "6652dd17dc34d5d744a4018dcb4589c2",
"assets/assets/audio/en-GB/usb_flash_drive.mp3": "da947026b3d7e7ba4170e03e388f4684",
"assets/assets/audio/en-GB/can_i_have_a_handheld_mic.mp3": "fec1465ffbe950463d6442e1ff85bb0e",
"assets/assets/audio/en-GB/i_can_t_log_in_to_the_computer.mp3": "ba1704a9b3cd67d3deb883828a0fb752",
"assets/assets/audio/en-GB/this_room_is_out_of_order_today.mp3": "4c85064d9a3bc2424e02e3d3f2506528",
"assets/assets/audio/en-GB/wait_a_moment_i_ll_restart_it.mp3": "3972b0c7515aaf181f3d8052c13e5ded",
"assets/assets/audio/en-GB/something_is_broken.mp3": "488e30a31631f7785d754882fb14d53f",
"assets/assets/audio/en-GB/do_you_have_a_stapler.mp3": "885a51c6928180a43a35e4bcb02401c2",
"assets/assets/audio/en-GB/i_ll_fix_the_keystone_so_it_s_not_slanted.mp3": "478be5455cb030c767ca65fc7375cd96",
"assets/assets/audio/en-GB/where_is_the_chalk.mp3": "9f60a7e72ead3308bb76407cdb02c13f",
"assets/assets/audio/en-GB/interactive_flat_panel.mp3": "a044cae56cd46dcc2345d245547be8c9",
"assets/assets/audio/en-GB/i_ll_restart_it_wait_a_moment.mp3": "54fd180010bd50d036ebd616cc33cb94",
"assets/assets/audio/en-GB/switch_the_input_to_hdmi_1.mp3": "8defaf4aa37d5bb2576eacbeb8020bd7",
"assets/assets/audio/en-GB/battery.mp3": "6e5aabf30c1d796012ba9606f9f83832",
"assets/assets/audio/en-GB/the_whole_sound_system_was_upgraded.mp3": "5a3b361592845acc8215b5e0f516cf0b",
"assets/assets/audio/en-GB/the_computer_is_frozen.mp3": "e228b743e9fecc8cbd748ad4ba417563",
"assets/assets/audio/en-GB/loose_connection.mp3": "13c865aad7f6fff1c445e8b6f10b0055",
"assets/assets/audio/en-GB/can_t_they_see_my_screen.mp3": "baaa53ad6605517d9512e1d725c524cb",
"assets/assets/audio/en-GB/there_s_a_power_outage_class_is_cancelled.mp3": "e1fc96a9eaf841fa510f68e985218b7f",
"assets/assets/audio/en-GB/feedback.mp3": "fd8eafb9455169fae226c40fd803a533",
"assets/assets/audio/en-GB/curtain.mp3": "d05ae19cff1ceb52e172b63df18f296f",
"assets/assets/audio/en-GB/please_sign_the_attendance_sheet.mp3": "1bd79868d4cdefb6d2f56e4ccf6c21f1",
"assets/assets/audio/en-GB/whiteboard_marker.mp3": "1a17c142dcf877e3bd118a23b6e11c61",
"assets/assets/audio/en-GB/press_screen_down_on_the_panel.mp3": "d04b36984b6af3934c40af1b7d968ad6",
"assets/assets/audio/en-GB/network_cable.mp3": "67ad514a6f100690bf88971860edce23",
"assets/assets/audio/en-GB/the_remote_control_doesn_t_respond.mp3": "154dd1dd9a4f1ae4190cd9b0f59ebba5",
"assets/assets/audio/en-GB/my_laptop_doesn_t_detect_the_hdmi.mp3": "12d5899d11028a61c9e8eeee32816b40",
"assets/assets/audio/en-GB/can_we_open_a_window.mp3": "f74bdd678873bf07a110ba58651741bc",
"assets/assets/audio/en-GB/the_clock_is_five_minutes_fast.mp3": "f78e9070976d2702838004573990666e",
"assets/assets/audio/en-GB/adjust_the_height_here.mp3": "fd90cf88bc93fd122be5d4f44a7a1911",
"assets/assets/audio/en-GB/the_light_switch_is_next_to_the_door.mp3": "b8028b1b271ee0c65ede07cd9846aa68",
"assets/assets/audio/en-GB/wireless_presenter.mp3": "dabc869db2d7e6609755f94413e5854e",
"assets/assets/audio/en-GB/the_amplifier_is_in_the_cabinet.mp3": "20e85e4c7892ae3fbdcff26f1fea8314",
"assets/assets/audio/en-GB/the_projector_won_t_turn_on.mp3": "deb29ce194fe14acc01d36075924c824",
"assets/assets/audio/en-GB/set_the_resolution_to_1920_by_1080.mp3": "efddbde6795d522e8fe94a6775c09c7a",
"assets/assets/audio/en-GB/repair.mp3": "d0c1c489370c474a571b3929b6ac69c6",
"assets/assets/audio/en-GB/the_microphone_keeps_cutting_out.mp3": "50ca52661de5e88129bce3a0381a67fb",
"assets/assets/audio/en-GB/not_working.mp3": "acaf4de51b7dfa956286831f94ab1c76",
"assets/assets/audio/en-GB/the_equipment_is_under_maintenance.mp3": "7adaf82cc865da7d3603993918218418",
"assets/assets/audio/en-GB/use_this_clicker_to_change_slides.mp3": "a4a0d7f777ab63d82537064862b75fb7",
"assets/assets/audio/en-GB/is_the_temperature_ok_for_you.mp3": "f4da5a6814ccfed8e64c1175ef1f4005",
"assets/assets/audio/en-GB/spare_bulb.mp3": "7e8f0981084f8e412027862e7cdf78cd",
"assets/assets/audio/en-GB/it_s_too_bright_in_here.mp3": "581bce4d975a9cc55e3e02f9927b3278",
"assets/assets/audio/en-GB/maintenance.mp3": "210f75d0ce91465ea92fad3c36fc0b46",
"assets/assets/audio/en-GB/the_fire_exit_is_over_there.mp3": "86a1a8ae5d3319771e9ce3750d6d9202",
"assets/assets/audio/en-GB/turn_the_volume_up_a_little.mp3": "016d8555c6aec115d3baa6f4ce91e7e0",
"assets/assets/audio/en-GB/attendance_sheet.mp3": "e1397806846d2856da64dd60aee7d8f2",
"assets/assets/audio/en-GB/it_s_too_dark_in_here.mp3": "5654a8929e6e871741414e20330aa7cd",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/AssetManifest.bin": "49230b679a44a2c4a2e929758f09d5ca",
"assets/AssetManifest.bin.json": "fa96d482195b74fb1b4b4b5156433b2e",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/NOTICES": "8ae3b3a77fd014587c922229bd55e6e2",
"assets/AssetManifest.json": "a6a9d374571f36b9e8c150bc140c28d2",
"assets/fonts/MaterialIcons-Regular.otf": "3fc77e7ac823576c0634078a6b7495d2",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"flutter_bootstrap.js": "cf33b6b9fe98ef4d1dd00e9be67f883c",
"manifest.json": "2631bf1674123d936fbbac8857713536",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"main.dart.js": "463ee660cdb477e0fce1fa36b7cac90d",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"index.html": "ec397baaafc72bddfb6cc13dc452b779",
"/": "ec397baaafc72bddfb6cc13dc452b779",
"version.json": "ede9a69b91feda7bb4497ebbccf7bafd"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
