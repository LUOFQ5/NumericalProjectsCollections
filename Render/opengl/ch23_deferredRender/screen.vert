#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aTexCoords;
uniform mat4 model;
uniform mat4 projection;
uniform mat4 view;
uniform mat4 lightSpaceMatrix;
out vec4 color;
out vec2 TexCoords;
out vec4 lightSpacePos;
out vec3 Normal;
out vec3 FragPos;

void main()
{ 
	gl_Position = projection * view * model * vec4(aPos , 1.0);
	color.xyz = aPos;
	TexCoords = aTexCoords;
	lightSpacePos = lightSpaceMatrix * model * vec4(aPos , 1.0);
	Normal = aNormal;
	FragPos = vec3(model * vec4(aPos, 1.0));

}