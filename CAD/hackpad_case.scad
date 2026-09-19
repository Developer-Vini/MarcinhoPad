// ============================================================
//  HACKPAD CASE  -  base + tampa (6 teclas MX 3x2, encoder EC11,
//  OLED 0.91", XIAO)   |   PCI 82 x 63 mm
//
//  Origem (0,0) = canto INFERIOR ESQUERDO da PCI, vista de cima
//  (mesma orientacao do print do KiCad). Unidades: mm.
//  Z = altura a partir do fundo da caixa.
//
//  Para gerar: mude PART abaixo e exporte (F6, depois F7 = STL).
// ============================================================

PART = "print";   // "print" | "base" | "lid" | "test_plate" | "assembly"

// ---------------- PCI ----------------
pcb_w = 82;        // X
pcb_h = 63;        // Y
pcb_t = 1.6;       // espessura

// ---------------- CAIXA ----------------
clear      = 0.2;  // folga entre PCI e parede (por lado)
wall       = 2.4;  // parede
floor_t    = 3.0;  // fundo
standoff_h = 3.5;  // vao sob a PCI (pinos dos switches + diodos)
gap_h      = 5.0;  // topo da PCI -> parte de baixo da tampa (padrao MX)
lid_t      = 1.5;  // espessura da tampa (1,5 = padrao pra placa de switch MX)
corner_r   = 2.5;  // raio dos cantos externos
ledge_w    = 1.0;  // faixa da borda da PCI que apoia na base

// ---------------- PARAFUSOS M2 (3 furos da PCI) ----------------
// Parafuso entra POR BAIXO: cabeca no fundo da base, rosca na tampa.
holes      = [[2, 2], [80, 2], [80, 61]];
m_d        = 2.4;  // furo passante na base
cb_d       = 4.4;  // rebaixo da cabeca
cb_depth   = 2.0;  // profundidade do rebaixo da cabeca
standoff_d = 5.0;  // pilarete da base
pillar_d   = 4.0;  // pilarete da tampa (nao passa da borda da PCI)
pilot_d    = 1.8;  // furo-piloto na tampa (rosca autoatarraxante M2)

// ---------------- TECLAS (centros dos switches) ----------------
key_x  = [12.9, 32.8, 52.8];   // colunas SW1/SW4, SW2/SW5, SW3/SW6
key_y  = [31.5, 12.0];         // fila de cima, fila de baixo
sw_cut = 14.6;                 // furo quadrado (14,0 + folga)

// ---------------- ENCODER (SW10) ----------------
enc_x   = 72.05;
enc_y   = 22.1;
enc_win = 13.0;   // janela quadrada: o corpo do EC11 (12 x 12) passa por ela

// ---------------- OLED 0.91" ----------------
oled_x = 47.3;
oled_y = 54.65;
oled_w = 24.4;    // area ativa 22,4 + margem
oled_h = 7.2;     // area ativa 5,6 + margem

// ---------------- USB-C (parede de cima) ----------------
usb_x = 13.0;
usb_w = 12.0;     // largura do recorte
usb_h = 6.0;      // altura do recorte
usb_z = 2.8;      // altura do centro do conector acima do topo da PCI

// ---------------- ENCAIXE DA TAMPA ----------------
lip_gap = 0.15;   // folga do rebordo da tampa dentro da parede
lip_t   = 1.0;    // espessura do rebordo
lip_h   = 1.5;    // quanto o rebordo desce

// ============ Derivados (nao precisa mexer) ============
z_pcb_bot = floor_t + standoff_h;
z_pcb_top = z_pcb_bot + pcb_t;
z_lid_bot = z_pcb_top + gap_h;
z_lid_top = z_lid_bot + lid_t;

ox0 = -(clear + wall);          ox1 = pcb_w + clear + wall;
oy0 = -(clear + wall);          oy1 = pcb_h + clear + wall;
px0 = -clear;                   py0 = -clear;
pw  = pcb_w + 2 * clear;        ph  = pcb_h + 2 * clear;

// ---------------- helpers ----------------
module rrect(x0, y0, x1, y1, r, h) {
    translate([x0 + r, y0 + r, 0])
        linear_extrude(h)
            offset(r = r, $fn = 48) square([x1 - x0 - 2 * r, y1 - y0 - 2 * r]);
}

module usb_cut() {
    translate([usb_x - usb_w / 2, pcb_h - 1.0, z_pcb_top + usb_z - usb_h / 2])
        cube([usb_w, 10, usb_h]);
}

// recortes da tampa (2D): teclas, encoder, OLED
module cutouts_2d() {
    for (x = key_x, y = key_y)
        translate([x - sw_cut / 2, y - sw_cut / 2]) square(sw_cut);
    translate([enc_x - enc_win / 2, enc_y - enc_win / 2]) square(enc_win);
    translate([oled_x - oled_w / 2, oled_y - oled_h / 2]) square([oled_w, oled_h]);
}

// ---------------- BASE ----------------
module base() {
    difference() {
        union() {
            // casca com rebaixo
            difference() {
                rrect(ox0, oy0, ox1, oy1, corner_r, z_lid_bot);
                translate([px0, py0, floor_t]) cube([pw, ph, z_lid_bot]);
            }
            // borda de apoio da PCI (perimetro)
            difference() {
                translate([px0, py0, floor_t - 0.01])
                    cube([pw, ph, standoff_h + 0.01]);
                translate([ledge_w, ledge_w, floor_t - 1])
                    cube([pcb_w - 2 * ledge_w, pcb_h - 2 * ledge_w, standoff_h + 3]);
            }
            // pilaretes
            for (h = holes)
                translate([h[0], h[1], floor_t - 0.01])
                    cylinder(d = standoff_d, h = standoff_h + 0.01, $fn = 48);
        }
        // furos + rebaixo da cabeca do parafuso
        for (h = holes) {
            translate([h[0], h[1], -1]) cylinder(d = m_d, h = z_pcb_bot + 2, $fn = 32);
            translate([h[0], h[1], -1]) cylinder(d = cb_d, h = cb_depth + 1, $fn = 32);
        }
        usb_cut();
    }
}

// ---------------- TAMPA (na posicao montada) ----------------
module lid() {
    difference() {
        union() {
            // placa da tampa
            translate([0, 0, z_lid_bot]) rrect(ox0, oy0, ox1, oy1, corner_r, lid_t);
            // rebordo de encaixe (nao passa pela area do XIAO)
            difference() {
                translate([0, 0, z_lid_bot - lip_h])
                    linear_extrude(lip_h + 0.01)
                        difference() {
                            translate([px0 + lip_gap, py0 + lip_gap])
                                square([pw - 2 * lip_gap, ph - 2 * lip_gap]);
                            translate([px0 + lip_gap + lip_t, py0 + lip_gap + lip_t])
                                square([pw - 2 * (lip_gap + lip_t), ph - 2 * (lip_gap + lip_t)]);
                        }
                translate([-6, 44, z_lid_bot - lip_h - 1]) cube([33, 30, lip_h + 2]);
            }
            // pilaretes que descem ate a PCI
            for (h = holes)
                translate([h[0], h[1], z_pcb_top])
                    cylinder(d = pillar_d, h = gap_h + 0.01, $fn = 40);
        }
        // furo-piloto (cego, nao aparece em cima)
        for (h = holes)
            translate([h[0], h[1], z_pcb_top - 0.01])
                cylinder(d = pilot_d, h = gap_h + 0.5, $fn = 24);
        // teclas, encoder, OLED
        translate([0, 0, z_lid_bot - 2]) linear_extrude(lid_t + 4) cutouts_2d();
        usb_cut();
    }
}

// tampa virada (face de cima na mesa), pronta pra imprimir sem suporte
module lid_flipped() {
    translate([0, oy0 + oy1, z_lid_top]) rotate([180, 0, 0]) lid();
}
// mesma coisa, mas deslocada pra ficar ao lado da base na mesa
module lid_print() {
    translate([0, (oy1 - oy0) + 8, 0]) lid_flipped();
}

// ---------------- PLACA DE TESTE ----------------
// Impressao rapida (~10 min) so pra conferir os furos ANTES de soldar:
// encaixe os switches nela e na PCI e veja se tudo entra sem forcar.
module test_plate() {
    linear_extrude(1.2)
        difference() {
            translate([-2, -2]) square([pcb_w + 4, pcb_h + 4]);
            cutouts_2d();
            for (h = holes) translate(h) circle(d = m_d, $fn = 32);
        }
}

// ---------------- SAIDA ----------------
if (PART == "base") base();
else if (PART == "lid") lid_flipped();
else if (PART == "test_plate") test_plate();
else if (PART == "assembly") {
    base();
    color("silver") lid();
    %translate([0, 0, z_pcb_bot]) cube([pcb_w, pcb_h, pcb_t]);
}
else { base(); lid_print(); }
