yyp_path = r'd:\MZ4\MegamanZ\MegamanZ.yyp'
with open(yyp_path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

new_objs = [
    'obj_boss_parent',
    'obj_nz_slash_hitbox',
    'obj_nz_crescent',
    'obj_nz_spike',
    'obj_nz_drill',
    'obj_nz_skull_wave',
    'obj_nz_ring_fx',
    'obj_nz_floor_burst',
    'obj_nightmare_zero'
]

# Check if already present
existing_text = "".join(lines)
objs_to_add = []
for obj in new_objs:
    if f'"{obj}"' not in existing_text:
        objs_to_add.append(f'    {{"id":{{"name":"{obj}","path":"objects/{obj}/{obj}.yy",}},}},\n')

if objs_to_add:
    new_lines = []
    for i, line in enumerate(lines):
        if line.strip() == '],' and i + 1 < len(lines) and 'resourceType' in lines[i + 1]:
            new_lines.extend(objs_to_add)
        new_lines.append(line)
    
    with open(yyp_path, 'w', encoding='utf-8') as f:
        f.writelines(new_lines)
    print(f"Added {len(objs_to_add)} objects to MegamanZ.yyp.")
else:
    print("All objects already present in MegamanZ.yyp.")
