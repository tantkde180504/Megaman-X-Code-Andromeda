// Mega Man X Custom Sprite Font Engine
// Renders text using the authentic Capcom fonts sprite sheet (sprites/fonts)

enum MMX_FONT {
    SMALL = 0,
    MEDIUM = 1,
    LARGE = 2
}

global.mmx_font_initialized = false;
global.mmx_font_small = array_create(256, [0, 0, 0, 0]);
global.mmx_font_med = array_create(256, [0, 0, 0, 0]);
global.mmx_font_large = array_create(256, [0, 0, 0, 0]);

function scr_mmx_font_init() {
    if (global.mmx_font_initialized) return;
    global.mmx_font_initialized = true;
    
    // Space glyphs
    global.mmx_font_small[ord(" ")] = [0, 0, 4, 16];
    global.mmx_font_med[ord(" ")] = [0, 0, 6, 16];
    global.mmx_font_large[ord(" ")] = [0, 0, 7, 16];

    // --- Small Font Glyphs ---
    global.mmx_font_small[33] = [113, 160, 5, 15]; // '!'
    global.mmx_font_small[39] = [170, 160, 2, 15]; // '''
    global.mmx_font_small[44] = [89, 160, 3, 15]; // ','
    global.mmx_font_small[45] = [65, 160, 6, 15]; // '-'
    global.mmx_font_small[46] = [98, 160, 2, 15]; // '.'
    global.mmx_font_small[47] = [65, 160, 6, 15]; // '/'
    global.mmx_font_small[48] = [1, 128, 6, 16]; // '0'
    global.mmx_font_small[49] = [18, 128, 4, 16]; // '1'
    global.mmx_font_small[50] = [33, 128, 6, 16]; // '2'
    global.mmx_font_small[51] = [49, 128, 6, 16]; // '3'
    global.mmx_font_small[52] = [65, 128, 6, 16]; // '4'
    global.mmx_font_small[53] = [80, 128, 7, 16]; // '5'
    global.mmx_font_small[54] = [97, 128, 6, 16]; // '6'
    global.mmx_font_small[55] = [112, 128, 8, 16]; // '7'
    global.mmx_font_small[56] = [129, 128, 6, 16]; // '8'
    global.mmx_font_small[57] = [145, 128, 6, 16]; // '9'
    global.mmx_font_small[58] = [170, 160, 2, 15]; // ':'
    global.mmx_font_small[63] = [129, 160, 6, 15]; // '?'
    global.mmx_font_small[65] = [160, 128, 7, 16]; // 'A'
    global.mmx_font_small[66] = [176, 128, 7, 16]; // 'B'
    global.mmx_font_small[67] = [192, 128, 7, 16]; // 'C'
    global.mmx_font_small[68] = [208, 128, 7, 16]; // 'D'
    global.mmx_font_small[69] = [224, 128, 7, 16]; // 'E'
    global.mmx_font_small[70] = [241, 128, 6, 16]; // 'F'
    global.mmx_font_small[71] = [1, 144, 7, 16]; // 'G'
    global.mmx_font_small[72] = [16, 144, 7, 16]; // 'H'
    global.mmx_font_small[73] = [34, 144, 4, 16]; // 'I'
    global.mmx_font_small[74] = [49, 144, 6, 16]; // 'J'
    global.mmx_font_small[75] = [64, 144, 8, 16]; // 'K'
    global.mmx_font_small[76] = [81, 144, 6, 16]; // 'L'
    global.mmx_font_small[77] = [96, 144, 7, 16]; // 'M'
    global.mmx_font_small[78] = [112, 144, 7, 16]; // 'N'
    global.mmx_font_small[79] = [128, 144, 7, 16]; // 'O'
    global.mmx_font_small[80] = [145, 144, 6, 16]; // 'P'
    global.mmx_font_small[81] = [160, 144, 7, 16]; // 'Q'
    global.mmx_font_small[82] = [176, 144, 7, 16]; // 'R'
    global.mmx_font_small[83] = [192, 144, 7, 16]; // 'S'
    global.mmx_font_small[84] = [209, 144, 6, 16]; // 'T'
    global.mmx_font_small[85] = [224, 144, 8, 16]; // 'U'
    global.mmx_font_small[86] = [241, 144, 6, 16]; // 'V'
    global.mmx_font_small[87] = [0, 160, 7, 15]; // 'W'
    global.mmx_font_small[88] = [16, 160, 8, 15]; // 'X'
    global.mmx_font_small[89] = [33, 160, 7, 15]; // 'Y'
    global.mmx_font_small[90] = [48, 160, 7, 15]; // 'Z'
    global.mmx_font_small[97] = global.mmx_font_small[65];
    global.mmx_font_small[98] = global.mmx_font_small[66];
    global.mmx_font_small[99] = global.mmx_font_small[67];
    global.mmx_font_small[100] = global.mmx_font_small[68];
    global.mmx_font_small[101] = global.mmx_font_small[69];
    global.mmx_font_small[102] = global.mmx_font_small[70];
    global.mmx_font_small[103] = global.mmx_font_small[71];
    global.mmx_font_small[104] = global.mmx_font_small[72];
    global.mmx_font_small[105] = global.mmx_font_small[73];
    global.mmx_font_small[106] = global.mmx_font_small[74];
    global.mmx_font_small[107] = global.mmx_font_small[75];
    global.mmx_font_small[108] = global.mmx_font_small[76];
    global.mmx_font_small[109] = global.mmx_font_small[77];
    global.mmx_font_small[110] = global.mmx_font_small[78];
    global.mmx_font_small[111] = global.mmx_font_small[79];
    global.mmx_font_small[112] = global.mmx_font_small[80];
    global.mmx_font_small[113] = global.mmx_font_small[81];
    global.mmx_font_small[114] = global.mmx_font_small[82];
    global.mmx_font_small[115] = global.mmx_font_small[83];
    global.mmx_font_small[116] = global.mmx_font_small[84];
    global.mmx_font_small[117] = global.mmx_font_small[85];
    global.mmx_font_small[118] = global.mmx_font_small[86];
    global.mmx_font_small[119] = global.mmx_font_small[87];
    global.mmx_font_small[120] = global.mmx_font_small[88];
    global.mmx_font_small[121] = global.mmx_font_small[89];
    global.mmx_font_small[122] = global.mmx_font_small[90];

    // --- Medium Font Glyphs ---
    global.mmx_font_med[33] = [118, 112, 4, 16]; // '!'
    global.mmx_font_med[34] = [150, 112, 6, 16]; // '"'
    global.mmx_font_med[39] = [150, 112, 6, 16]; // '''
    global.mmx_font_med[43] = [52, 112, 8, 16]; // '+'
    global.mmx_font_med[44] = [84, 112, 3, 16]; // ','
    global.mmx_font_med[45] = [68, 112, 7, 16]; // '-'
    global.mmx_font_med[46] = [100, 112, 2, 16]; // '.'
    global.mmx_font_med[47] = [68, 112, 7, 16]; // '/'
    global.mmx_font_med[48] = [4, 48, 8, 16]; // '0'
    global.mmx_font_med[49] = [21, 48, 5, 16]; // '1'
    global.mmx_font_med[50] = [35, 48, 9, 16]; // '2'
    global.mmx_font_med[51] = [52, 48, 8, 16]; // '3'
    global.mmx_font_med[52] = [67, 48, 9, 16]; // '4'
    global.mmx_font_med[53] = [83, 48, 9, 16]; // '5'
    global.mmx_font_med[54] = [99, 48, 8, 16]; // '6'
    global.mmx_font_med[55] = [115, 48, 9, 16]; // '7'
    global.mmx_font_med[56] = [131, 48, 9, 16]; // '8'
    global.mmx_font_med[57] = [148, 48, 8, 16]; // '9'
    global.mmx_font_med[58] = [84, 112, 3, 16]; // ':'
    global.mmx_font_med[63] = [132, 112, 7, 16]; // '?'
    global.mmx_font_med[65] = [163, 48, 10, 16]; // 'A'
    global.mmx_font_med[66] = [178, 48, 10, 16]; // 'B'
    global.mmx_font_med[67] = [195, 48, 10, 16]; // 'C'
    global.mmx_font_med[68] = [210, 48, 10, 16]; // 'D'
    global.mmx_font_med[69] = [228, 48, 9, 16]; // 'E'
    global.mmx_font_med[70] = [244, 48, 9, 16]; // 'F'
    global.mmx_font_med[71] = [3, 64, 10, 16]; // 'G'
    global.mmx_font_med[72] = [19, 64, 10, 16]; // 'H'
    global.mmx_font_med[73] = [38, 64, 5, 16]; // 'I'
    global.mmx_font_med[74] = [51, 64, 9, 16]; // 'J'
    global.mmx_font_med[75] = [67, 64, 11, 16]; // 'K'
    global.mmx_font_med[76] = [83, 64, 8, 16]; // 'L'
    global.mmx_font_med[77] = [98, 64, 11, 16]; // 'M'
    global.mmx_font_med[78] = [114, 64, 10, 16]; // 'N'
    global.mmx_font_med[79] = [131, 64, 10, 16]; // 'O'
    global.mmx_font_med[80] = [148, 64, 9, 16]; // 'P'
    global.mmx_font_med[81] = [163, 64, 10, 16]; // 'Q'
    global.mmx_font_med[82] = [178, 64, 10, 16]; // 'R'
    global.mmx_font_med[83] = [195, 64, 9, 16]; // 'S'
    global.mmx_font_med[84] = [211, 64, 9, 16]; // 'T'
    global.mmx_font_med[85] = [227, 64, 10, 16]; // 'U'
    global.mmx_font_med[86] = [243, 64, 9, 16]; // 'V'
    global.mmx_font_med[87] = [2, 80, 12, 16]; // 'W'
    global.mmx_font_med[88] = [18, 80, 11, 16]; // 'X'
    global.mmx_font_med[89] = [35, 80, 9, 16]; // 'Y'
    global.mmx_font_med[90] = [51, 80, 10, 16]; // 'Z'
    global.mmx_font_med[97] = [67, 80, 8, 16]; // 'a'
    global.mmx_font_med[98] = [84, 80, 8, 16]; // 'b'
    global.mmx_font_med[99] = [100, 80, 8, 16]; // 'c'
    global.mmx_font_med[100] = [115, 80, 9, 16]; // 'd'
    global.mmx_font_med[101] = [132, 80, 8, 16]; // 'e'
    global.mmx_font_med[102] = [149, 80, 5, 16]; // 'f'
    global.mmx_font_med[103] = [163, 80, 9, 16]; // 'g'
    global.mmx_font_med[104] = [180, 80, 8, 16]; // 'h'
    global.mmx_font_med[105] = [197, 80, 4, 16]; // 'i'
    global.mmx_font_med[106] = [213, 80, 6, 16]; // 'j'
    global.mmx_font_med[107] = [228, 80, 8, 16]; // 'k'
    global.mmx_font_med[108] = [246, 80, 4, 16]; // 'l'
    global.mmx_font_med[109] = [2, 96, 11, 16]; // 'm'
    global.mmx_font_med[110] = [20, 96, 8, 16]; // 'n'
    global.mmx_font_med[111] = [36, 96, 8, 16]; // 'o'
    global.mmx_font_med[112] = [51, 96, 9, 16]; // 'p'
    global.mmx_font_med[113] = [68, 96, 8, 16]; // 'q'
    global.mmx_font_med[114] = [85, 96, 6, 16]; // 'r'
    global.mmx_font_med[115] = [100, 96, 7, 16]; // 's'
    global.mmx_font_med[116] = [117, 96, 5, 16]; // 't'
    global.mmx_font_med[117] = [132, 96, 8, 16]; // 'u'
    global.mmx_font_med[118] = [148, 96, 8, 16]; // 'v'
    global.mmx_font_med[119] = [162, 96, 11, 16]; // 'w'
    global.mmx_font_med[120] = [179, 96, 9, 16]; // 'x'
    global.mmx_font_med[121] = [196, 96, 8, 16]; // 'y'
    global.mmx_font_med[122] = [212, 96, 8, 16]; // 'z'

    // --- Large Font Glyphs ---
    global.mmx_font_large[33] = [128, 32, 4, 16]; // '!'
    global.mmx_font_large[44] = [178, 32, 3, 16]; // ','
    global.mmx_font_large[45] = [67, 32, 11, 16]; // '-'
    global.mmx_font_large[46] = [162, 32, 2, 16]; // '.'
    global.mmx_font_large[47] = [67, 32, 11, 16]; // '/'
    global.mmx_font_large[48] = [4, 0, 9, 16]; // '0'
    global.mmx_font_large[49] = [21, 0, 5, 16]; // '1'
    global.mmx_font_large[50] = [35, 0, 9, 16]; // '2'
    global.mmx_font_large[51] = [51, 0, 9, 16]; // '3'
    global.mmx_font_large[52] = [66, 0, 9, 16]; // '4'
    global.mmx_font_large[53] = [83, 0, 9, 16]; // '5'
    global.mmx_font_large[54] = [99, 0, 9, 16]; // '6'
    global.mmx_font_large[55] = [116, 0, 9, 16]; // '7'
    global.mmx_font_large[56] = [131, 0, 9, 16]; // '8'
    global.mmx_font_large[57] = [147, 0, 9, 16]; // '9'
    global.mmx_font_large[58] = [178, 32, 3, 16]; // ':'
    global.mmx_font_large[63] = [144, 32, 6, 16]; // '?'
    global.mmx_font_large[65] = [162, 0, 11, 16]; // 'A'
    global.mmx_font_large[66] = [179, 0, 11, 16]; // 'B'
    global.mmx_font_large[67] = [195, 0, 11, 16]; // 'C'
    global.mmx_font_large[68] = [211, 0, 11, 16]; // 'D'
    global.mmx_font_large[69] = [227, 0, 11, 16]; // 'E'
    global.mmx_font_large[70] = [243, 0, 12, 16]; // 'F'
    global.mmx_font_large[71] = [3, 16, 11, 16]; // 'G'
    global.mmx_font_large[72] = [19, 16, 12, 16]; // 'H'
    global.mmx_font_large[73] = [38, 16, 5, 16]; // 'I'
    global.mmx_font_large[74] = [52, 16, 9, 16]; // 'J'
    global.mmx_font_large[75] = [67, 16, 11, 16]; // 'K'
    global.mmx_font_large[76] = [84, 16, 9, 16]; // 'L'
    global.mmx_font_large[77] = [97, 16, 14, 16]; // 'M'
    global.mmx_font_large[78] = [115, 16, 12, 16]; // 'N'
    global.mmx_font_large[79] = [131, 16, 11, 16]; // 'O'
    global.mmx_font_large[80] = [147, 16, 11, 16]; // 'P'
    global.mmx_font_large[81] = [163, 16, 11, 16]; // 'Q'
    global.mmx_font_large[82] = [179, 16, 11, 16]; // 'R'
    global.mmx_font_large[83] = [195, 16, 11, 16]; // 'S'
    global.mmx_font_large[84] = [212, 16, 11, 16]; // 'T'
    global.mmx_font_large[85] = [227, 16, 12, 16]; // 'U'
    global.mmx_font_large[86] = [244, 16, 11, 16]; // 'V'
    global.mmx_font_large[87] = [2, 32, 13, 16]; // 'W'
    global.mmx_font_large[88] = [18, 32, 12, 16]; // 'X'
    global.mmx_font_large[89] = [36, 32, 11, 16]; // 'Y'
    global.mmx_font_large[90] = [51, 32, 11, 16]; // 'Z'
    global.mmx_font_large[97] = global.mmx_font_large[65];
    global.mmx_font_large[98] = global.mmx_font_large[66];
    global.mmx_font_large[99] = global.mmx_font_large[67];
    global.mmx_font_large[100] = global.mmx_font_large[68];
    global.mmx_font_large[101] = global.mmx_font_large[69];
    global.mmx_font_large[102] = global.mmx_font_large[70];
    global.mmx_font_large[103] = global.mmx_font_large[71];
    global.mmx_font_large[104] = global.mmx_font_large[72];
    global.mmx_font_large[105] = global.mmx_font_large[73];
    global.mmx_font_large[106] = global.mmx_font_large[74];
    global.mmx_font_large[107] = global.mmx_font_large[75];
    global.mmx_font_large[108] = global.mmx_font_large[76];
    global.mmx_font_large[109] = global.mmx_font_large[77];
    global.mmx_font_large[110] = global.mmx_font_large[78];
    global.mmx_font_large[111] = global.mmx_font_large[79];
    global.mmx_font_large[112] = global.mmx_font_large[80];
    global.mmx_font_large[113] = global.mmx_font_large[81];
    global.mmx_font_large[114] = global.mmx_font_large[82];
    global.mmx_font_large[115] = global.mmx_font_large[83];
    global.mmx_font_large[116] = global.mmx_font_large[84];
    global.mmx_font_large[117] = global.mmx_font_large[85];
    global.mmx_font_large[118] = global.mmx_font_large[86];
    global.mmx_font_large[119] = global.mmx_font_large[87];
    global.mmx_font_large[120] = global.mmx_font_large[88];
    global.mmx_font_large[121] = global.mmx_font_large[89];
    global.mmx_font_large[122] = global.mmx_font_large[90];
}

// Convert any accented characters to standard ASCII for authentic retro Mega Man rendering
function string_mmx_clean(_str) {
    var _out = _str;
    // Common Vietnamese uppercase & lowercase mappings
    var _from = ["Á","À","Ả","Ã","Ạ","Ă","Ắ","Ằ","Ẳ","Ẵ","Ặ","Â","Ấ","Ầ","Ẩ","Ẫ","Ậ",
                 "á","à","ả","ã","ạ","ă","ắ","ằ","ẳ","ẵ","ặ","â","ấ","ầ","ẩ","ẫ","ậ",
                 "É","È","Ẻ","Ẽ","Ẹ","Ê","Ế","Ề","Ể","Ễ","Ệ",
                 "é","è","ẻ","ẽ","ẹ","ê","ế","ề","ể","ễ","ệ",
                 "Í","Ì","Ỉ","Ĩ","Ị","í","ì","ỉ","ĩ","ị",
                 "Ó","Ò","Ỏ","Õ","Ọ","Ô","Ố","Ồ","Ổ","Ỗ","Ộ","Ơ","Ớ","Ờ","Ở","Ỡ","Ợ",
                 "ó","ò","ỏ","õ","ọ","ô","ố","ồ","ổ","ỗ","ộ","ơ","ớ","ờ","ở","ỡ","ợ",
                 "Ú","Ù","Ủ","Ũ","Ụ","Ư","Ứ","Ừ","Ử","Ữ","Ự",
                 "ú","ù","ủ","ũ","ụ","ư","ứ","ừ","ử","ữ","ự",
                 "Ý","Ỳ","Ỷ","Ỹ","Ỵ","ý","ỳ","ỷ","ỹ","ỵ",
                 "Đ","đ"];
    var _to =   ["A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A",
                 "a","a","a","a","a","a","a","a","a","a","a","a","a","a","a","a","a",
                 "E","E","E","E","E","E","E","E","E","E","E",
                 "e","e","e","e","e","e","e","e","e","e","e",
                 "I","I","I","I","I","i","i","i","i","i",
                 "O","O","O","O","O","O","O","O","O","O","O","O","O","O","O","O","O",
                 "o","o","o","o","o","o","o","o","o","o","o","o","o","o","o","o","o",
                 "U","U","U","U","U","U","U","U","U","U","U",
                 "u","u","u","u","u","u","u","u","u","u","u",
                 "Y","Y","Y","Y","Y","y","y","y","y","y",
                 "D","d"];
    for (var i = 0; i < array_length(_from); i++) {
        _out = string_replace_all(_out, _from[i], _to[i]);
    }
    return _out;
}

// Draw formatted Mega Man text using fonts sprite
function draw_mmx_text(_x, _y, _text, _font = MMX_FONT.SMALL, _xscale = 1.0, _yscale = 1.0, _col = c_white, _alpha = 1.0) {
    if (!global.mmx_font_initialized) scr_mmx_font_init();
    if (!sprite_exists(fonts)) return 0;
    
    var _clean = string_mmx_clean(_text);
    var _table;
    switch (_font) {
        case MMX_FONT.MEDIUM: _table = global.mmx_font_med; break;
        case MMX_FONT.LARGE:  _table = global.mmx_font_large; break;
        default:              _table = global.mmx_font_small; break;
    }
    
    var _cx = _x;
    var _cy = _y;
    var _len = string_length(_clean);
    var _line_h = 16 * _yscale;
    var _tracking = 1 * _xscale;
    var _max_w = 0;
    
    for (var i = 1; i <= _len; i++) {
        var _char = string_char_at(_clean, i);
        if (_char == "\n") {
            _max_w = max(_max_w, _cx - _x);
            _cx = _x;
            _cy += _line_h;
            continue;
        }
        
        var _code = ord(_char);
        if (_code >= 0 && _code < 256) {
            var _g = _table[_code];
            var _gw = _g[2];
            var _gh = _g[3];
            if (_gw > 0) {
                // If not space, draw sprite part
                if (_char != " ") {
                    draw_sprite_part_ext(fonts, 0, _g[0], _g[1], _gw, _gh, _cx, _cy, _xscale, _yscale, _col, _alpha);
                }
                _cx += (_gw * _xscale) + _tracking;
            } else {
                // Fallback space width
                _cx += 4 * _xscale;
            }
        } else {
            _cx += 4 * _xscale;
        }
    }
    _max_w = max(_max_w, _cx - _x);
    return _max_w;
}

// Measure pixel width of text
function string_mmx_width(_text, _font = MMX_FONT.SMALL, _xscale = 1.0) {
    if (!global.mmx_font_initialized) scr_mmx_font_init();
    var _clean = string_mmx_clean(_text);
    var _table;
    switch (_font) {
        case MMX_FONT.MEDIUM: _table = global.mmx_font_med; break;
        case MMX_FONT.LARGE:  _table = global.mmx_font_large; break;
        default:              _table = global.mmx_font_small; break;
    }
    var _w = 0;
    var _max_w = 0;
    var _len = string_length(_clean);
    var _tracking = 1 * _xscale;
    for (var i = 1; i <= _len; i++) {
        var _char = string_char_at(_clean, i);
        if (_char == "\n") {
            _max_w = max(_max_w, _w);
            _w = 0;
            continue;
        }
        var _code = ord(_char);
        if (_code >= 0 && _code < 256) {
            var _gw = _table[_code][2];
            _w += (_gw > 0 ? _gw * _xscale : 4 * _xscale) + _tracking;
        } else {
            _w += 4 * _xscale;
        }
    }
    return max(_max_w, _w);
}

// Draw dialogue with typewriter char count limitation
function draw_mmx_dialogue_line(_x, _y, _text, _char_count, _font = MMX_FONT.SMALL, _xscale = 1.0, _yscale = 1.0, _col = c_white, _alpha = 1.0) {
    var _clean = string_mmx_clean(_text);
    var _sub = string_copy(_clean, 1, _char_count);
    return draw_mmx_text(_x, _y, _sub, _font, _xscale, _yscale, _col, _alpha);
}

/// @desc Word wrap measured with the actual small bitmap font at native scale.
function ps1_text_lines(_text, _width) {
    var _lines = [];
    var _paragraphs = string_split(string_mmx_clean(_text), "\n");
    for (var _p = 0; _p < array_length(_paragraphs); _p++) {
        var _words = string_split(_paragraphs[_p], " ");
        var _line = "";
        for (var _w = 0; _w < array_length(_words); _w++) {
            var _word = _words[_w];
            var _candidate = (_line == "") ? _word : _line + " " + _word;
            if (_line != "" && string_mmx_width(_candidate) > _width) {
                array_push(_lines, _line);
                _line = "";
            }
            // Split an oversized token too, so labels cannot escape the panel.
            for (var _c = 1; _c <= string_length(_word); _c++) {
                if (_c == 1 && _line != "") _line += " ";
                var _char = string_char_at(_word, _c);
                if (_line != "" && string_mmx_width(_line + _char) > _width) {
                    array_push(_lines, _line);
                    _line = "";
                }
                _line += _char;
            }
        }
        array_push(_lines, _line);
    }
    return _lines;
}

function ps1_text_pages(_text, _width, _rows) {
    var _lines = ps1_text_lines(_text, _width);
    var _pages = [];
    for (var _i = 0; _i < array_length(_lines); _i += _rows) {
        var _page = "";
        for (var _r = 0; _r < _rows && _i + _r < array_length(_lines); _r++) {
            if (_r > 0) _page += "\n";
            _page += _lines[_i + _r];
        }
        array_push(_pages, _page);
    }
    return _pages;
}

/// @desc Draw inside a native-pixel text box; wrap the full text before revealing.
function ps1_draw_text(_x, _y, _text, _width, _height, _colour = c_white, _visible = -1, _alpha = 1) {
    var _lines = ps1_text_lines(_text, _width);
    var _remaining = (_visible < 0) ? string_length(_text) + 1000 : _visible;
    var _rows = min(array_length(_lines), floor(_height / 16));
    for (var _r = 0; _r < _rows; _r++) {
        var _line = _lines[_r];
        draw_mmx_text(round(_x), round(_y + _r * 16),
            string_copy(_line, 1, max(0, _remaining)), MMX_FONT.SMALL, 1, 1, _colour, _alpha);
        _remaining -= string_length(_line) + 1;
    }
}

function ps1_draw_centered(_cx, _y, _text, _width, _colour = c_white) {
    var _lines = ps1_text_lines(_text, _width);
    for (var _r = 0; _r < array_length(_lines); _r++) {
        var _line = _lines[_r];
        draw_mmx_text(round(_cx - string_mmx_width(_line) * 0.5), round(_y + _r * 16),
            _line, MMX_FONT.SMALL, 1, 1, _colour);
    }
}

function ps1_draw_panel(_x, _y, _width, _height, _border = c_aqua) {
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(6, 18, 42));
    draw_rectangle(_x, _y, _x + _width - 1, _y + _height - 1, false);
    draw_set_color(_border);
    draw_rectangle(_x, _y, _x + _width - 1, _y + _height - 1, true);
}
