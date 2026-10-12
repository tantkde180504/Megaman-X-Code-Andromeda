yyp_path = r'd:\MZ4\MegamanZ\MegamanZ.yyp'
with open(yyp_path, 'r', encoding='utf-8') as f:
    text = f.read()

spr_names = [
    'spr_nz_spawn', 'spr_nz_idle', 'spr_nz_run', 'spr_nz_slash_big', 'spr_nz_dash_slash',
    'spr_nz_crescent_proj', 'spr_nz_crescent_small', 'spr_nz_ground_charge', 'spr_nz_ground_spike',
    'spr_nz_shoot', 'spr_nz_ring_fx', 'spr_nz_drill_proj', 'spr_nz_air', 'spr_nz_dome',
    'spr_nz_skull_wave', 'spr_nz_floor_burst', 'spr_nz_hurt', 'spr_nz_down', 'spr_nz_death_ooze'
]

new_entries = []
for name in spr_names:
    if f'"{name}"' not in text:
        new_entries.append(f'    {{"id":{{"name":"{name}","path":"sprites/{name}/{name}.yy",}},}},')

if new_entries:
    insert_str = '\n'.join(new_entries) + '\n'
    idx = text.find('  "RoomOrderNodes":')
    if idx != -1:
        text = text[:idx] + insert_str + text[idx:]
        with open(yyp_path, 'w', encoding='utf-8') as f:
            f.write(text)
        print(f'Added {len(new_entries)} sprite entries to MegamanZ.yyp')
    else:
        print('Could not find insertion point')
else:
    print('All sprites already in MegamanZ.yyp')
