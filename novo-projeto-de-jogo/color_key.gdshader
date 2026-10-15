shader_type canvas_item;

// Cor de fundo sólida a ser removida (Color Key / Chroma Key)
uniform vec4 color_to_remove : source_color = vec4(0.0, 0.0, 0.0, 1.0);

// Margem de tolerância para capturar variações e artefatos de compressão
uniform float tolerance : hint_range(0.0, 1.0) = 0.15;

// Margens de corte relativas de cada célula (elimina divisórias pretas e caixas do spritesheet)
uniform float margin_x : hint_range(0.0, 0.3) = 0.0;
uniform float margin_y : hint_range(0.0, 0.3) = 0.0;

// Quantidade de colunas (hframes) e linhas (vframes) da grade da sprite
uniform int h_frames : hint_range(1, 16) = 1;
uniform int v_frames : hint_range(1, 16) = 1;

void fragment() {
	// 1. Eliminação cirúrgica de bordas externas e caixas da célula do spritesheet
	if (margin_x > 0.0 || margin_y > 0.0) {
		vec2 frame_dim = vec2(1.0 / float(h_frames), 1.0 / float(v_frames));
		vec2 local_uv = fract(UV / frame_dim);
		if (local_uv.x < margin_x || local_uv.x > (1.0 - margin_x) ||
		    local_uv.y < margin_y || local_uv.y > (1.0 - margin_y)) {
			discard;
		}
	}

	vec4 tex_color = texture(TEXTURE, UV);
	
	// Se a textura já for transparente no canal alfa, descarta imediatamente
	if (tex_color.a <= 0.01) {
		discard;
	}
	
	// 2. Calcula a distância euclidiana entre a cor do pixel e a cor alvo
	float dist = distance(tex_color.rgb, color_to_remove.rgb);
	
	// Se estiver dentro da tolerância, descarta o pixel completamente do pipeline
	if (dist <= tolerance) {
		discard;
	}
	
	COLOR = tex_color * COLOR;
}
