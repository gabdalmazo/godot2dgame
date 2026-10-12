shader_type canvas_item;

// Cor de fundo sólida a ser removida (Color Key / Chroma Key)
uniform vec4 color_to_remove : source_color = vec4(0.0, 0.0, 0.0, 1.0);

// Margem de tolerância para capturar variações e artefatos de compressão
uniform float tolerance : hint_range(0.0, 1.0) = 0.1;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	
	// Calcula a distância euclidiana entre a cor do pixel e a cor alvo no espaço RGB
	float dist = distance(tex_color.rgb, color_to_remove.rgb);
	
	// Se a cor for igual ou estiver dentro da tolerância, torna o pixel totalmente invisível
	if (dist <= tolerance) {
		tex_color.a = 0.0;
	}
	
	// Multiplica por COLOR para manter compatibilidade com modulações do CanvasItem
	COLOR = tex_color * COLOR;
}
