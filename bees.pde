//bees.pde file below

var bees = []; var flowers = [];

void setup() {
	size(400, 400);
	for (var i = 0; i < 10; i++) {
		bees[i] = new Bee(random(3, 8), random(width), random(height), random(-2, 2));
	}
	for (var i = 0; i < 10; i++) {
		flowers[i] = new Flower(random(width), random(0.7*height, 0.85*height), random(40, 100), color(random(255),random(255),random(255)));
	}
}

var Mover = function(m, x, y, vh) {
    this.mass = m;
    this.position = new PVector(x, y);
    this.velocity = new PVector(vh, 0);
    this.acceleration = new PVector(0, 0);
};

Mover.prototype.applyForce = function(force) {
    var f = PVector.div(force, this.mass);
    this.acceleration.add(f);
};

Mover.prototype.update = function() {
    this.velocity.add(this.acceleration);
    this.position.add(this.velocity);
    this.acceleration.mult(0);
};

Mover.prototype.checkEdges = function() {

    if (this.position.x > width) {
        this.position.x = 0;
    } else if (this.position.x < 0) {
        this.position.x = width;
    }
    
    if (this.position.y > height) {
        this.position.y = 0;
    } else if (this.position.y < 0) {
        this.position.y = height;
    }
};

// Simulates Newton's second law
// Receive a force, divide by mass, add to acceleration
Mover.prototype.applyForce = function(force) {
    var f = PVector.div(force, this.mass);
    this.acceleration.add(f);
};

var Bee = function(m, x, y, vh) {
	Mover.call(this, m, x, y, vh);
	this.w = 3*this.mass;
	this.h = 3*this.mass;
};

Bee.prototype = Object.create(Mover.prototype);

Bee.prototype.display = function() {
	
	noStroke();
	fill(color(238, 238, 0));
	//draw body segments
	ellipse(this.position.x + this.w*0.6, this.position.y, this.w, this.h*0.9);	
	ellipse(this.position.x, this.position.y, this.w, this.h*0.9);
	fill(color(50, 50, 50));
	rect(this.position.x, this.position.y - this.h/2, this.w*0.6, this.h);
	//draw eye
	fill(color(238, 238, 0));
	stroke(0);
	strokeWeight(2);
	if (this.velocity.x >= 0) {
		point(this.position.x + this.w, this.position.y);
	} else {
		point(this.position.x - 0.4*this.w, this.position.y);
	}
	//draw wings
	noStroke();
	fill(230, 230, 230, 200);
	ellipse(this.position.x, this.position.y - this.h*0.5, this.w*0.4, this.h);
};

var Flower = function(x, y, hght, colour) {
    this.position = new PVector(x, y);
    this.hght = hght;
	this.colour = colour;
};

//Calculate attractive force between flowers and bees
Flower.prototype.calculateAttraction = function(bee) {
    // Calculate direction of force
    var force = PVector.sub(this.position, bee.position);
    // Distance between objects
    var distance = force.mag();
    // Limiting the distance to eliminate "extreme" results for very close or very far objects
    distance = constrain(distance, 5.0, 25.0);
    // Normalize vector (distance doesn't matter here, we just want this vector for direction                            
    force.normalize();
    // Calculate attractive force magnitude
	//assume bees of greater mass have greater attractive force - greedier
	//assume attractive force inversely proportional to distance
    var strength = bee.mass/ distance;
    // Get force vector --> magnitude * direction
    force.mult(strength);
    return force;
};

Flower.prototype.display = function() {
	noStroke();
	fill(0, 139, 69);
	//draw stem
	rect(this.position.x, this.position.y, 3, -this.hght);
	//draw flower head
	fill(this.colour);
	ellipse(this.position.x + 1.5, this.position.y - this.hght, 10, 10);
	//draw petals
	ellipse(this.position.x + 1.5 - 10, this.position.y - this.hght, 22, 10);
	ellipse(this.position.x + 1.5 + 10, this.position.y - this.hght, 22, 10);
	ellipse(this.position.x + 1.5, this.position.y - this.hght - 10, 10, 22);
	ellipse(this.position.x + 1.5, this.position.y - this.hght + 10, 10, 22);
	//draw leaves
	pushMatrix();
	fill(0, 139, 69);
	translate(this.position.x, this.position.y);
	rotate((20/180)*3.141);
	ellipse(0, -15, 5, 30);
	rotate((-40/180)*3.141);
	ellipse(0, -15, 5, 30);
	popMatrix();
};

var drawGrass = function() {
	noStroke();
	fill(color(0, 255, 0));
	rect(0, height*0.7, width, height*0.3);
};

var drawSky = function() {
	noStroke();
	fill(color(0, 191, 255));
	rect(0, 0, width, height*0.7);
};

void draw() {
	background(200, 200, 200);
	drawGrass();
	drawSky();
	
	var wind = new PVector(random(-0.01, 0.01), 0);
    var gravity = new PVector(0, 0.1);
	var uplift = new PVector(0, random(-0.2, 0));
	
	for (var i = 0; i < flowers.length; i++) {
		 flowers[i].display();
    }
	for (var i = 0; i < bees.length; i++) {
		 bees[i].applyForce(gravity);
		 bees[i].applyForce(wind);
		 //force due to bees flapping wings
		 bees[i].applyForce(uplift);
		 bees[i].update();
		 bees[i].checkEdges();
		 bees[i].display();
    }
	
};
