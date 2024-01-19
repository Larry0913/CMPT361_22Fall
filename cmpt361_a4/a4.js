import { Mat4 } from './math.js';
import { Parser } from './parser.js';
import { Scene } from './scene.js';
import { Renderer } from './renderer.js';
import { TriangleMesh } from './trianglemesh.js';
// DO NOT CHANGE ANYTHING ABOVE HERE

////////////////////////////////////////////////////////////////////////////////
// TODO: Implement createCube, createSphere, computeTransformation, and shaders
////////////////////////////////////////////////////////////////////////////////

// Example two triangle quad
const quad = {
  positions: [-1, -1, -1, 1, -1, -1, 1, 1, -1, -1, -1, -1, 1,  1, -1, -1,  1, -1],
  normals: [0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1],
  uvCoords: [0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1]
}

TriangleMesh.prototype.createCube = function() {
  // TODO: populate unit cube vertex positions, normals, and uv coordinates
  this.positions = [
    //front
    1, -1, 1, -1, 1, 1, -1, -1, 1,
    1, 1, 1, -1, 1, 1, 1, -1, 1,
    //top
    1, -1, -1, 1, 1, 1, 1, -1, 1,
    1, 1, -1, 1, 1, 1, 1, -1, -1,
    //right
    1, 1, 1, -1, 1, -1, -1, 1, 1,
    1, 1, -1, -1, 1, -1, 1, 1, 1,
    //left
    1, -1, -1, -1, -1, 1, -1, -1, -1,
    1, -1, 1, -1, -1, 1, 1, -1, -1,
    //bottom
    -1, -1, 1, -1, 1, -1, -1, -1, -1,
    -1, 1, 1, 1, 1, 1, 1, -1, -1,
    //back
    1, 1, -1, -1, -1, -1, -1, 1, -1,
    1, -1, -1, -1, -1, -1, 1, 1, -1,
  ];
  this.normals = this.positions;
  this.uvCoords = [
    //front
    0, 1, 1/2, 2/3, 0, 2/3,
    1/2, 1, 1/2, 2/3, 0, 1,
    //top
    0, 2/3, 1/2, 1/3, 0, 1/3,
    1/2, 2/3, 1/2, 1/3, 0, 2/3,
    //right
    0, 1/3, 1/2, 0, 0, 0,
    1/2, 1/3, 1/2, 0, 0, 1/3,
    //left
    1/2, 1, 1, 2/3, 1/2, 2/3,
    1, 1, 1, 2/3, 1/2, 1, 
    //bottom 
    1/2, 2/3, 1, 1/3, 1/2, 1/3,
    1, 2/3, 1, 1/3, 1/2, 2/3,
    //back
    1, 1/3, 1/2, 0, 1/2, 1/3,
    1, 0, 1/2, 0, 1, 1/3,  
  ];
}

TriangleMesh.prototype.createSphere = function(numStacks, numSectors) {
  // TODO: populate unit sphere vertex positions, normals, uv coordinates, and indices
  let x, y, z, xy, nx, ny, nz, s, t;
  let radius = 1;
  let lengthInv = 1.0 / radius;

  let sectorStep = 2 *  Math.PI / numSectors;
  let stackStep =  Math.PI / numStacks;
  let sectorAngle, stackAngle;

  for(let i = 0; i <= numStacks; ++i)
  {
    stackAngle = Math.PI / 2 - i * stackStep;        // starting from pi/2 to -pi/2
    xy = radius * Math.cos(stackAngle);             // r * cos(u)
    z = radius * Math.sin(stackAngle);              // r * sin(u)

    // add (sectorCount+1) vertices per stack
    // the first and last vertices have same position and normal, but different tex coords
    for(let j = 0; j <= numSectors; ++j)
    {
        sectorAngle = j * sectorStep;           // starting from 0 to 2pi

        // vertex position (x, y, z)
        x = xy * Math.cos(sectorAngle);             // r * cos(u) * cos(v)
        y = xy * Math.sin(sectorAngle);             // r * cos(u) * sin(v)
        this.positions.push(x);
        this.positions.push(y);
        this.positions.push(z);

        // normalized vertex normal (nx, ny, nz)
        nx = x * lengthInv;
        ny = y * lengthInv;
        nz = z * lengthInv;
        this.normals.push(nx);
        this.normals.push(ny);
        this.normals.push(nz);

        // vertex tex coord (s, t) range between [0, 1]
        s = j / numSectors;
        t = i / numStacks;
        this.uvCoords.push(1-s);
        this.uvCoords.push(t);
    }
  }

  let k1, k2;
  for(let i = 0; i < numStacks; ++i)
  {
    k1 = i * (numSectors + 1);     // beginning of current stack
    k2 = k1 + numSectors + 1;      // beginning of next stack

    for(let j = 0; j < numSectors; ++j, ++k1, ++k2)
    {
      // 2 triangles per sector excluding first and last stacks
      // k1 => k2 => k1+1
      if(i != 0)
      {
          this.indices.push(k1);
          this.indices.push(k2);
          this.indices.push(k1 + 1);
      }

      // k1+1 => k2 => k2+1
      if(i != (numStacks-1)) 
      {
          this.indices.push(k1 + 1);
          this.indices.push(k2);
          this.indices.push(k2 + 1);
      }
    }
  }
}

Scene.prototype.computeTransformation = function(transformSequence) {
  // TODO: go through transform sequence and compose into overallTransform
  let overallTransform = Mat4.create();  // identity matrix
  for(let i = transformSequence.length-1; i>=0; i--){
    let transformResult = [];
    let o = Mat4.create();
    if (transformSequence[i][0] == "Rx"){
        transformResult = Mat4.set(o, 
        1, 0, 0, 0, 
        0, Math.cos((Math.PI/180)*(-transformSequence[i][1])), -Math.sin((Math.PI/180)*(-transformSequence[i][1])), 0, 
        0, Math.sin((Math.PI/180)*(-transformSequence[i][1])), Math.cos((Math.PI/180)*(-transformSequence[i][1])), 0, 
        0, 0, 0, 1);
      }

      if (transformSequence[i][0] == "Ry"){
        transformResult = Mat4.set(o, 
        Math.cos((Math.PI/180)*(-transformSequence[i][1])), 0, Math.sin((Math.PI/180)*(-transformSequence[i][1])), 0, 
        0, 1, 0, 0,
        -Math.sin((Math.PI/180)*(-transformSequence[i][1])), 0, Math.cos((Math.PI/180)*(-transformSequence[i][1])), 0, 
        0, 0, 0, 1);
      }

      if (transformSequence[i][0] == "Rz"){
        transformResult = Mat4.set(o, 
        Math.cos((Math.PI/180)*(-transformSequence[i][1])), -Math.sin((Math.PI/180)*(-transformSequence[i][1])), 0, 0, 
        Math.sin((Math.PI/180)*(-transformSequence[i][1])), Math.cos((Math.PI/180)*(-transformSequence[i][1])), 0, 0, 
        0, 0, 1, 0,
        0, 0, 0, 1);  
      }

      if (transformSequence[i][0] == "S"){           
      transformResult = Mat4.set(o, 
        transformSequence[i][1], 0, 0, 0,
        0, transformSequence[i][2], 0, 0, 
        0, 0, transformSequence[i][3], 0,
        0, 0, 0, 1);
      }
      
      if (transformSequence[i][0] == "T"){
        transformResult = Mat4.set(Mat4.create(), 
        1, 0, 0, 0,
        0, 1, 0, 0, 
        0, 0, 1, 0, 
        transformSequence[i][1], transformSequence[i][2], transformSequence[i][3], 1);
      }  
    Mat4.multiply(overallTransform, overallTransform, transformResult);
  }
  return overallTransform;
}

Renderer.prototype.VERTEX_SHADER = `
precision mediump float;
attribute vec3 position, normal;
attribute vec2 uvCoord;
uniform vec3 lightPosition;
uniform mat4 projectionMatrix, viewMatrix, modelMatrix;
uniform mat3 normalMatrix;
varying vec2 vTexCoord;

// TODO: implement vertex shader logic below

varying vec3 temp;
varying vec3 fragmentNormal;
varying vec3 fragmentPosition;
varying vec3 L;
varying float d;

void main() {
  temp = vec3(position.x, normal.x, uvCoord.x);
  vTexCoord = uvCoord;
  gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(position, 1.0);
  fragmentNormal = normalize(normalMatrix * normal);
  fragmentPosition = (viewMatrix * modelMatrix * vec4(position, 1.0)).xyz;
  L = normalize(lightPosition - position); 
  d = -(viewMatrix * modelMatrix * viewMatrix * modelMatrix* vec4(position, 1.0)).z; 
}
`;

Renderer.prototype.FRAGMENT_SHADER = `
precision mediump float;
uniform vec3 ka, kd, ks, lightIntensity;
uniform float shininess;
uniform sampler2D uTexture;
uniform bool hasTexture;
varying vec2 vTexCoord;

// TODO: implement fragment shader logic below

varying vec3 temp;
varying vec3 fragmentPosition;
varying vec3 fragmentNormal;
varying vec3 L;
varying float d;

void main() {
  //Phong reflection model
  vec3 ca = ka * lightIntensity;
  vec3 cd = (kd/d) * max(0.0, dot(fragmentNormal, L)) * lightIntensity;
  vec3 h = normalize(-normalize(fragmentPosition) + L);
  vec3 cs = (ks/d) * pow(max(0.0, dot(h, fragmentNormal)), shininess) * lightIntensity;
  
  vec3 color = ca + cd + cs;
  
  if(hasTexture){  
    gl_FragColor = vec4(color, 1.0) * texture2D(uTexture, vTexCoord);
  }
  else{
    gl_FragColor = vec4(color, 1.0);
  }
}
`;

////////////////////////////////////////////////////////////////////////////////
// EXTRA CREDIT: change DEF_INPUT to create something interesting!
////////////////////////////////////////////////////////////////////////////////
const DEF_INPUT = [
  "c,myCamera,perspective,5,5,5,0,0,0,0,1,0;",
  "l,myLight,point,0,5,0,2,2,2;",
  "p,unitCube,cube;",
  "p,unitSphere,sphere,20,20;",
  "m,redDiceMat,0.3,0,0,0.7,0,0,1,1,1,15,dice.jpg;",
  "m,grnDiceMat,0,0.3,0,0,0.7,0,1,1,1,15,dice.jpg;",
  "m,bluDiceMat,0,0,0.3,0,0,0.7,1,1,1,15,dice.jpg;",
  "m,globeMat,0.3,0.3,0.3,0.7,0.7,0.7,1,1,1,5,globe.jpg;",
  "o,rd,unitCube,redDiceMat;",
  "o,gd,unitCube,grnDiceMat;",
  "o,bd,unitCube,bluDiceMat;",
  "o,gl,unitSphere,globeMat;",
  "X,rd,Rz,75;X,rd,Rx,90;X,rd,S,0.5,0.5,0.5;X,rd,T,-1,0,2;",
  "X,gd,Ry,45;X,gd,S,0.5,0.5,0.5;X,gd,T,2,0,2;",
  "X,bd,S,0.5,0.5,0.5;X,bd,Rx,90;X,bd,T,2,0,-1;",
  "X,gl,S,1.5,1.5,1.5;X,gl,Rx,90;X,gl,Ry,-150;X,gl,T,0,1.5,0;",
].join("\n");

// DO NOT CHANGE ANYTHING BELOW HERE
export { Parser, Scene, Renderer, DEF_INPUT };
