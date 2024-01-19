import { Framebuffer } from './framebuffer.js';
import { Rasterizer } from './rasterizer.js';
// DO NOT CHANGE ANYTHING ABOVE HERE

////////////////////////////////////////////////////////////////////////////////
// TODO: Implement functions drawLine(v1, v2) and drawTriangle(v1, v2, v3) below.
////////////////////////////////////////////////////////////////////////////////

// take two vertices defining line and rasterize to framebuffer
Rasterizer.prototype.drawLine = function(v1, v2) {
  const [x1, y1, [r1, g1, b1]] = v1;
  const [x2, y2, [r2, g2, b2]] = v2;
  // TODO/HINT: use this.setPixel(x, y, color) in this function to draw line
  this.setPixel(Math.floor(x1), Math.floor(y1), [r1, g1, b1]);
  this.setPixel(Math.floor(x2), Math.floor(y2), [r2, g2, b2]);
  // Determine whether it is a vertical line
  var pixel_r_difference;
  var pixel_g_difference;
  var pixel_b_difference;
  //create rgb for each pixel
  var pixel_r_c;
  var pixel_g_c;
  var pixel_b_c;
  if(x1 == x2){
    var distance_y = Math.abs(y2 - y1);
    //Determine the difference between two vertex
    if(r1 > r2){
      pixel_r_difference = (-1)*Math.abs(r2 - r1)/distance_y;
    } 
    else{
      pixel_r_difference = Math.abs(r2 - r1)/distance_y;
    }
    if(g1 > g2){
      pixel_g_difference = (-1)*Math.abs(g2 - g1)/distance_y;
    } 
    else{
      pixel_g_difference = Math.abs(g2 - g1)/distance_y;
    }
    if(b1 > b2){
      pixel_b_difference = (-1)*Math.abs(b2 - b1)/distance_y;
    } 
    else{
      pixel_b_difference = Math.abs(b2 - b1)/distance_y;
    }
    //create rgb for each pixel
    pixel_r_c = r1;
    pixel_g_c = r1;
    pixel_b_c = r1;

    if (y1 > y2){
      var y = y1;
      for(let i = y2; i <= y1; i++ ){
        pixel_r_c += pixel_r_difference;
        pixel_g_c += pixel_g_difference;
        pixel_b_c += pixel_b_difference;
        this.setPixel(x1, y, [pixel_r_c, pixel_g_c, pixel_b_c]);
        y--;
      }
    }
    else{
      for(let j = y1; j <= y2; j++ ){
        pixel_r_c += pixel_r_difference;
        pixel_g_c += pixel_g_difference;
        pixel_b_c += pixel_b_difference;
        this.setPixel(x1, j, [pixel_r_c, pixel_g_c, pixel_b_c]);
      }
    }
  }
  else {
    var slope = (y2 - y1) / (x2 - x1);
    var y = y1;
    var distance_x = Math.abs(x2 - x1);
    if(r1 > r2){
      pixel_r_difference = (-1)*Math.abs(r2 - r1)/distance_x;
    } 
    else{
      pixel_r_difference = Math.abs(r2 - r1)/distance_x;
    }
    if(g1 > g2){
      pixel_g_difference = (-1)*Math.abs(g2 - g1)/distance_x;
    } 
    else{
      pixel_g_difference = Math.abs(g2 - g1)/distance_x;
    }
    if(b1 > b2){
      pixel_b_difference = (-1)*Math.abs(b2 - b1)/distance_x;
    } 
    else{
      pixel_b_difference = Math.abs(b2 - b1)/distance_x;
    }
    //create rgb for each pixel
    pixel_r_c = r1;
    pixel_g_c = r1;
    pixel_b_c = r1;
    if (x2 < x1){
      y = y2;
      var x = x1;
      for (let i = x2; i <= x1; i++) {
        y += slope;
        pixel_r_c += pixel_r_difference;
        pixel_g_c += pixel_g_difference;
        pixel_b_c += pixel_b_difference;
        this.setPixel(x, Math.round(y), [pixel_r_c, pixel_g_c, pixel_b_c]);
        x--;
      }
    } else {
      for (let j = x1; j <= x2; j++) {
        y += slope;
        pixel_r_c += pixel_r_difference;
        pixel_g_c += pixel_g_difference;
        pixel_b_c += pixel_b_difference;
        this.setPixel(j, Math.round(y), [pixel_r_c, pixel_g_c, pixel_b_c]);
        
      }
    }
  }
}

// take 3 vertices defining a solid triangle and rasterize to framebuffer
Rasterizer.prototype.drawTriangle = function(v1, v2, v3) {
  const [x1, y1, [r1, g1, b1]] = v1;
  const [x2, y2, [r2, g2, b2]] = v2;
  const [x3, y3, [r3, g3, b3]] = v3;
  // TODO/HINT: use this.setPixel(x, y, color) in this function to draw triangle
  this.setPixel(Math.floor(x1), Math.floor(y1), [r1, g1, b1]);
  this.setPixel(Math.floor(x2), Math.floor(y2), [r2, g2, b2]);
  this.setPixel(Math.floor(x3), Math.floor(y3), [r3, g3, b3]);

  let i_1 = Math.ceil(Math.min(x1, x2, x3));
  let i_2 = Math.ceil(Math.max(x1, x2, x3));
  let j_1 = Math.ceil(Math.min(y1, y2, y3));
  let j_2 = Math.ceil(Math.max(y1, y2, y3));

  for (let i = i_1; i <= i_2; i++) {
    for (let j = j_1; j <= j_2; j++) {
      var color = barycentricCoordinates(v1,v2,v3,i,j);
      if (pointIsInsideTriangle(v1, v2, v3, i, j)) {
        this.setPixel(i, Math.round(j), color);
      }
    }
  }
}

function pointIsInsideTriangle(v1,v2,v3, x, y){
  const [x1, y1, [r1, g1, b1]] = v1;
  const [x2, y2, [r2, g2, b2]] = v2;
  const [x3, y3, [r3, g3, b3]] = v3;
  let a_1 = y2 - y1;
  let b_1 = x1 - x2;
  let c_1 = x2 * y1 - x1 * y2;
  let a_2 = y3 - y2;
  let b_2 = x2 - x3;
  let c_2 = x3 * y2 - x2 * y3;

  let a_3 = y1 - y3;
  let b_3 = x3 - x1;
  let c_3 = x1 * y3 - x3 * y1;

  var ans1;
  var ans2;
  var ans3;
  var result1 = a_1 * x + b_1 * y + c_1;
  var result2 = a_2 * x + b_2 * y + c_2;
  var result3 = a_3 * x + b_3 * y + c_3;
  if (result1 >= 0){
    ans1 = true;
  }
  else{
    ans1 = false;
  }
  if (result2 >= 0){
    ans2 = true;
  }
  else{
    ans2 = false;
  }
  if (result3 >= 0){
    ans3 = true;
  }
  else{
    ans3 = false;
  }
  
  if(ans1 && ans2 && ans3){
    return true;
  }else
  {
    return false;
  }
}

function barycentricCoordinates(v1,v2,v3,x, y)
  {
    const [x1, y1, [r1, g1, b1]] = v1;
    const [x2, y2, [r2, g2, b2]] = v2;    
    const [x3, y3, [r3, g3, b3]] = v3;
    let A = 0.5 * Math.abs(x1*(y2-y3)+x2*(y3-y1)+x3*(y1-y2)); 
    let A0 = 0.5 * Math.abs(x*(y2-y3)+x2*(y3-y)+x3*(y-y2)); 
    let A1 = 0.5 * Math.abs(x*(y1-y3)+x1*(y3-y)+x3*(y-y1));         
    let A2 = 0.5 * Math.abs(x*(y1-y2)+x1*(y2-y) +x2*(y-y1));        
    let u = A0 / A;
    let v = A1 / A;
    let w = A2 / A;
    let r_c = u * r1 + v * r2 + w * r3;
    let g_c = u * g1 + v * g2 + w * g3;
    let b_c = u * b1 + v * b2 + w * b3;
    var color = [r_c, g_c, b_c];
    return color;
  }


////////////////////////////////////////////////////////////////////////////////
// EXTRA CREDIT: change DEF_INPUT to create something interesting!
////////////////////////////////////////////////////////////////////////////////
const DEF_INPUT = [
  "v,10,10,1.0,0.0,0.0;",
  "v,52,52,0.0,1.0,0.0;",
  "v,52,10,0.0,0.0,1.0;",
  "v,10,52,1.0,1.0,1.0;",
  "t,0,1,2;",
  "t,0,3,1;",
  "v,10,10,1.0,1.0,1.0;",
  "v,10,52,0.0,0.0,0.0;",
  "v,52,52,1.0,1.0,1.0;",
  "v,52,10,0.0,0.0,0.0;",
  "l,4,5;",
  "l,5,6;",
  "l,6,7;",
  "l,7,4;"
].join("\n");


// DO NOT CHANGE ANYTHING BELOW HERE
export { Rasterizer, Framebuffer, DEF_INPUT };
