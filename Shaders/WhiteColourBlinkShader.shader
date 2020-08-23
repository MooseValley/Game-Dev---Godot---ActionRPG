shader_type canvas_item;

// Like export variables in GDScript.  This makes it appear in the GUI Properties Sheet.
uniform bool active = false;

void fragment()
{
	//vec4 previousColour = texture(TEXTURE, UV);
	//COLOR = vec4(1.0, 1.0, 1.0, 1.0);
	vec4 previousColour = texture(TEXTURE, UV);
	
	if (active == true)
	{
		vec4 whiteColour = vec4(1.0, 1.0, 1.0, previousColour.a); // White with pixel's existing alpha value
		COLOR = whiteColour;
	}
	else
	{
		COLOR = previousColour;
	}		
}
