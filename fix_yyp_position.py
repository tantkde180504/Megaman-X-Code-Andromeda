yyp_path = r'd:\MZ4\MegamanZ\MegamanZ.yyp'
with open(yyp_path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

spr_lines = []
other_lines = []
for line in lines:
    if 'spr_nz_' in line:
        spr_lines.append(line)
    else:
        other_lines.append(line)

# find where resources ends: '  ],\n' right before '  "resourceType":"GMProject",\n'
new_lines = []
for i, line in enumerate(other_lines):
    if line.strip() == '],' and i + 1 < len(other_lines) and 'resourceType' in other_lines[i + 1]:
        # insert spr_lines right before this line
        new_lines.extend(spr_lines)
    new_lines.append(line)

with open(yyp_path, 'w', encoding='utf-8') as f:
    f.writelines(new_lines)

print('Fixed MegamanZ.yyp cleanly.')
