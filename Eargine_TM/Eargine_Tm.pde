import processing.sound.*;
import processing.serial.*;

Serial puerto; // Definir variable puerto como serial

PImage icono, logo, simico, ARDico, infoico, salirico, es, en, itermometro, iregla, ifrecuencia, volumenico, silencioico, oido, huesecillos, iingles, iespañol;

color colorg1 = color(90, 130, 230), colorg2 = color(255, 100, 100);

SoundFile click;

boolean control2 = false, boton = false, plotcontrol = true, nuevoData = false, mainMenu = false, renderGrafica = false, inicio = true, simulador = false, ARDUINO = false, Info = false, over = false, control=false, pestana=false, cambio=true;

int espaciox = 5;   // Distancia entre cada objeto generado sobre el eje horizontal
int w;              // Ancho entero de la onda
int i, j;
int opacidad = 0;
int t=0, c2=0, cont=0;
int c4=0;
int ultimaaltura = height;
int trans = 255;
int val=0;
int selectop, selectop2;

float ultimaxPos = 1;
float serialdata;  // Entrada de información serial
float xPos = 1; // Posición horizontal de la gráfica
float red=0, blue= 252;
float dragX=10, Xdrag=width*5.4;
float C, K;
float teta = 0.0;  // Empezamos el ángulo en 0
float amplitud = 50;  // Amplitud de la onda
float periodo = 500.0;  // Pixeles antes de que la onda repita
float dx;  // Valor para incrementar X. Esta es una función que relaciona el periodo con el espacio en x
float[] y;  // Usamos un vector que funcionará como una función. En él se guardaran los valores de y en función de x
float temp=10, tamaño=width*0.08, freq=20;
float smax=0.1;
float moverx=width*7.75;
float vel=0, densidad=0, kelvin=0, beta=0, periodo1=0, k=0, lambda=0, omega=0, pmax=0, amp=0, angulo=0, angulo2=0, x2=0; //variables usadas para el cálculo de fórmulas físicas
float s2=width*0.252;
float x=0;
float presion[]=new float[3000];
float desplazamiento[]=new float[3000];
float[] s = new float[3000]; //vector desplazamiento
float[] p= new float[3000];
float armonico;

String idioma = "español", sim, info, comienzo, salir, datos, gráfica, stemperatura, samplitud, sfrecuencia, grafica1, grafica2, azul, rojo, verde, morado;

void setup () {
  size(1000, 650);
  background(240);
  frameRate(60);
  smooth();
  puerto=new Serial(this, "COM5", 9600); //puerto serial arduino
  logo = loadImage ("logow.png");
  icono = loadImage ("logo.png");//carga de imagenes
  simico = loadImage ("earw.png");
  ARDico = loadImage ("motherboardw.png");
  infoico = loadImage ("bookmarkw.png");
  salirico = loadImage ("salirw.png");
  es = loadImage ("es.png");
  en = loadImage ("en.png");
  itermometro = loadImage("temp.png");
  iregla = loadImage("Reglasi.png");
  ifrecuencia=loadImage("frecuencia.png");
  volumenico = loadImage ("volumenw.png");
  silencioico = loadImage ("silenciow.png");
  oido = loadImage("oidomedio.png");
  huesecillos = loadImage("huesecillos.png");
  iingles = loadImage("textoingles.PNG");
  iespañol = loadImage("textoespanol.png");
  surface.setIcon(icono);
  surface.setTitle("Eargine");
  click = new SoundFile(this, "click.mp3");
  click.amp(0.1);
  click.rate(2);
  w = width+15;
  dx = (TWO_PI / periodo) * espaciox;
  y = new float [w/espaciox];
  s2=width*0.252;
  c2=0;
  val=0;
  // Un evento serial es generado cuando el salto de linea se recibe:
  puerto.bufferUntil('\n');
}

void draw() {
  if (idioma == "español") {
    sim = "Simulador";   //cambio de idioma a español
    info = "Info";
    comienzo = "Haz click aquí para comenzar";
    datos = "Suministro de datos";
    gráfica = "Gráfica";
    salir = "Salir";
    stemperatura = "Temperatura";
    samplitud = "Amplitud";
    sfrecuencia = "Frecuencia";
    grafica1 = "Color gráfica desplazamiento";
    grafica2 = "Color gráfica presión";
    azul = "Azul";
    rojo = "Rojo";
    verde = "Verde";
    morado = "Morado";
  } else {
    sim = "Simulator";
    info = "Info";
    comienzo = "Click here to start"; //cambio de idioma a inglés
    datos = "Data supply";
    gráfica = "Graphic";
    salir = "Exit";
    stemperatura = "Temperature";
    samplitud = "Amplitude";
    sfrecuencia = "Frequency";
    grafica1 = "Color graphic of displacement";
    grafica2 = "Color graphic of pressure";
    azul = "Blue";
    rojo = "Red";
    verde = "Green";
    morado = "Purple";
  }
  inicio(); //procedimientos en el draw
  mainMenu();
  calcOnda();
  simulador();
  ARDUINO();
  Info();
  if (over == false) {
    cursor(ARROW); //cambio de pulsor del mouse
  } else {
    cursor(HAND);
  }
}

void calcOnda() {
  // Incrementa el valor de teta para variar la velocidad angular
  teta += 0.02;
  // Para todos los valores de x, se calcula un valor de y con la función seno
  float x = teta;
  for (int i = 0; i < y.length; i++) {
    y[i] = sin(x)*amplitud;
    x+=dx;
  }
}

void inicio() {
  if (inicio) {
    background(90, 130, 230);
    imageMode(CENTER);
    image(logo, width/2, height/3, height/2, height/2); //pantalla de inicio
    image(en, width*0.9, height*0.075, 40, 40);
    image(es, width*0.95, height*0.075, 40, 40);
    if (mouseX >= width*0.88 && mouseX <= width*0.88+40 && mouseY >= height*0.04 && mouseY <= height*0.04+40) {
      over = true;
      if (mousePressed && mouseButton == LEFT) { //boton cambio de idioma a ingles
        idioma = "english";
        click.play();
        mousePressed = false;
      }
    } else if (mouseX >= width*0.93 && mouseX <= width*0.93+40 && mouseY >= height*0.04 && mouseY <= height*0.04+40) {
      over = true;
      if (mousePressed && mouseButton == LEFT) {
        idioma = "español"; //boton cambio de idioma español
        click.play();
        mousePressed = false;
      }
    } else {
      over = false;
    }
    if (idioma == "español") {
      fill(255, 255, 255, 100); //centro del texto de ingles
      textSize(42);
      textMode(CENTER);
      text(comienzo, width/4, height*0.65); //texto con baja opacidad "Haz click aquí..."
      fill(255);
      textSize(32);
      textMode(CENTER);
      if (mouseX >= width/4 && mouseX <= width*0.76 && mouseY >= height*0.6 && mouseY <= height*0.67) {
        over = true;
        fill(255, 255, 255, 255);
        textSize(42);
        text(comienzo, width/4, height*0.65); //texto resaltado "Haz click aquí..."
        if (mousePressed && mouseButton == LEFT) {
          mainMenu = true;
          inicio = false;
          simulador = true;
          click.play();
          mousePressed = false;
        }
      }
    } else if (idioma == "english") {
      fill(255, 255, 255, 100);
      textSize(42);
      textMode(CENTER);
      text(comienzo, width*0.34, height*0.65); //texto con baja opacidad "Haz click aquí..."
      fill(255);
      textSize(32);
      textMode(CENTER);
      if (mouseX >= width*0.34 && mouseX <= width*0.635 && mouseY >= height*0.6 && mouseY <= height*0.67) {
        over = true;
        fill(255, 255, 255, 255);
        textSize(42);
        text(comienzo, width*0.34, height*0.65); //texto resaltado "Haz click aquí..."
        if (mousePressed && mouseButton == LEFT) {
          mainMenu = true;
          inicio = false;
          simulador = true;
          click.play();
          mousePressed = false;
        }
      }
    }
    noStroke();
    fill(255);
    for (int x = 0; x < y.length; x++) {
      ellipse(2 * x * espaciox, height + y[x], 200, 200); //dibujo de la onda a través de elipses
    }
    fill(0, 0, 0, 100);
    textSize(18);
    text("NordSoftware", width*0.43, height*0.98);
    textSize(12);
    text("TM", width*0.54, height*0.97);
  }
}

void mainMenu() {
  if (mainMenu) { //menu principal
    imageMode(CORNER);
    if ((control==false && simulador==true)||(control2==false && ARDUINO==true)) {
      background(240);
      fill(255);
      control=true;
      control2=true;
    } else if (simulador==false && ARDUINO == false) {
      background(240);
    }
    fill(90, 130, 230);
    noStroke();
    rect(0, 0, width*0.25, height);
    image(logo, width*0.02, height*0.01, width*0.2, width*0.2); //zona del simulador
    fill(255);
    textSize(28);
    text(sim, width*0.07, height*0.4);
    image(simico, 20, height*0.36, 30, 30);
    text("Arduino", width*0.07, height*0.5);//zona de arduino
    image(ARDico, 20, height*0.46, 30, 30);
    text(info, width*0.07, height*0.845);
    image(infoico, 20, height*0.81, 30, 30);//zona de informacion
    text(salir, width*0.07, height*0.945);
    image(salirico, 20, height*0.91, 30, 30);//zona de salir
    fill(255, 255, 255, 100);
    noStroke();
    if (mouseX >= 10 && mouseX <= 240 && mouseY >= height*0.35 && mouseY <= height*0.35+45) {
      rect(10, height*0.35, 225, 45, 10, 10, 10, 10);
      over = true;
      if (mousePressed && mouseButton == LEFT) {
        simulador = true;
        ARDUINO = false;
        Info = false;
        click.play();
        pestana = false;
        mousePressed = false;
      }
    } else if (mouseX >= 10 && mouseX <= 240 && mouseY >= height*0.45 && mouseY <= height*0.45+45) {
      rect(10, height*0.45, 225, 45, 10, 10, 10, 10);
      over = true;
      if (mousePressed && mouseButton == LEFT) {
        simulador = false;
        ARDUINO = true;
        Info = false;
        click.play();
        mousePressed = false;
      }
    } else if (mouseX >= 10 && mouseX <= 240 && mouseY >= height*0.8 && mouseY <= height*0.8+45) {
      rect(10, height*0.8, 225, 45, 10, 10, 10, 10);
      over = true;
      if (mousePressed && mouseButton == LEFT) {
        simulador = false;
        ARDUINO = false;
        Info = true;
        click.play();
        mousePressed = false;
      }
    } else if (mouseX >= 10 && mouseX <= 240 && mouseY >= height*0.9 && mouseY <= height*0.9+45) {
      rect(10, height*0.9, 225, 45, 10, 10, 10, 10);
      over = true;
      if (mousePressed && mouseButton == LEFT) {
        click.play();
        mousePressed = false;
        exit();
      }
    } else {
      over = false;
    }
  }
}

void simulador() {
  if (simulador) {
    if (pestana == false) {
      background(240);
      boton = false;
      trans = 255;
      fill(90, 130, 230);
      rect(0, 0, width*0.25, height);
      fill(255, 255, 255, 100);
      if (mouseX >= 10 && mouseX <= 240 && mouseY >= height*0.35 && mouseY <= height*0.35+45) {
        rect(10, height*0.35, 225, 45, 10, 10, 10, 10);
        if (mousePressed && mouseButton == LEFT) {
          simulador = true;
          ARDUINO = false;
          Info = false;
          pestana = true;
          click.play();
          mousePressed = false;
        }
      } else if (mouseX >= 10 && mouseX <= 240 && mouseY >= height*0.45 && mouseY <= height*0.45+45) {
        rect(10, height*0.45, 225, 45, 10, 10, 10, 10);
      } else if (mouseX >= 10 && mouseX <= 240 && mouseY >= height*0.8 && mouseY <= height*0.8+45) {
        rect(10, height*0.8, 225, 45, 10, 10, 10, 10);
      } else if (mouseX >= 10 && mouseX <= 240 && mouseY >= height*0.9 && mouseY <= height*0.9+45) {
        rect(10, height*0.9, 225, 45, 10, 10, 10, 10);
      }
      image(logo, width*0.02, height*0.01, width*0.2, width*0.2);
      fill(255);
      textSize(28);
      text(sim, width*0.07, height*0.4);
      image(simico, 20, height*0.36, 30, 30);
      text("Arduino", width*0.07, height*0.5);
      image(ARDico, 20, height*0.46, 30, 30);
      text(info, width*0.07, height*0.845);
      image(infoico, 20, height*0.81, 30, 30);
      text(salir, width*0.07, height*0.945);
      image(salirico, 20, height*0.91, 30, 30);
      fill(255, 255, 255, 100);
      noStroke();
      fill(240);
      rect(10, height*0.35, 240, 45, 10, 0, 0, 10);
      fill(0);
      text(sim, width*0.07, height*0.4);
      tint(90, 130, 230);
      image(simico, 20, height*0.36, 30, 30);
      tint(255);
      fill(255);
      rect(width*0.275, height*0.075, width*0.225, height*0.35, 10, 10, 10, 10);
      rect(width*0.5125, height*0.075, width*0.225, height*0.35, 10, 10, 10, 10);
      rect(width*0.75, height*0.075, width*0.225, height*0.35, 10, 10, 10, 10);
      fill(0);
      textSize(21);
      text(datos, width*0.275, height*0.05);
      fill(240);
      rect(width*0.285, height*0.21, width*0.205, height*0.08, 10, 10, 10, 10);
      fill(190);
      rect(width*0.3, height*0.236, width*0.175, height*0.025, 10, 10, 10, 10);
      fill(mouseDragged(width*0.3 + width*0.205, width*0.3, width*0.01, width*0.175), 0, 252 - mouseDragged(width*0.3 + width*0.205, width*0.3, width*0.01, width*0.175));
      rect(width*0.3, height*0.236, dragX, height*0.025, 10, 10, 10, 10);
      fill(0);
      text(stemperatura, width*0.34, height*0.15);
      image(itermometro, width*0.31, height*0.115, width*0.0235, width*0.035 );
      text(stemperatura, width*0.34, height*0.15);
      fill(244);
      rect(width*0.335, height*0.325, width*0.105, width*0.035, width*0.01);
      fill(mouseDragged(width*0.3 + width*0.205, width*0.3, width*0.01, width*0.175), 0, 252 - mouseDragged(width*0.3 + width*0.205, width*0.3, width*0.01, width*0.175));
      temp = (27* (mouseDragged(width*0.3 + width*0.205, width*0.3, width*0.01, width*0.175)-width*0.01)/(width*0.165)) +10;
      text(temp, width*0.35, height*0.36);
      text("°C", width*0.415, height*0.36);

      // Amplitud
      fill(240);
      rect(width*0.525, height*0.21, width*0.205, height*0.08, 10, 10, 10, 10);
      fill(190);
      triangle(width*0.54, height*0.25, width*(0.54+0.175), height*0.23, width*(0.54+0.175), height*0.27);
      ellipse(width*(0.54+0.17), height*0.25, width*0.027, width*0.026);
      noStroke();
      fill(0);
      text(samplitud, width*0.5925, height*0.15 );
      image(iregla, width*0.555, height*0.115, width*0.035, width*0.035);
      ellipse(movertemp(width*(0.54+0.175), width*0.54), height*0.2485, tamaño(width*(0.54+0.175), width*0.54), tamaño(width*(0.54+0.175), width*0.54));
      fill(244);
      rect(width*0.575, height*0.325, width*0.105, width*0.035, width*0.01);
      fill(0);
      text(smax, width*0.585, height*0.36);
      text("m", width*0.645, height*0.36);
      smax= ((Xdrag - width*0.54)*width* 0.000010855 +0.1);

      // Frecuencia
      fill(0);
      text(sfrecuencia, width*0.835, height*0.15);
      fill(240);
      rect(width*0.76, height*0.21, width*0.205, height*0.08, 10, 10, 10, 10);
      fill(190);
      rect(width*0.775, height*0.245, width*0.175, height*0.005, 10, 10, 10, 10);
      image(ifrecuencia, width*0.775, height*0.115, width*0.05, width*0.035 );
      fill(0);
      rect(fecuencia(width*0.95, width*0.775), height*0.225, width*0.0025, height*0.05, 20);
      fill(244);
      rect(width*0.79, height*0.325, width*0.14, width*0.035, width*0.01);
      fill(0);
      text(freq, width*0.8, height*0.36);
      text("Hz", width*0.9, height*0.36);
      freq= ((moverx - width*0.775)*width* 0.11417143 +20);
      fill(90, 130, 230);
      ellipseMode(CORNER);
      ellipse(width*0.575, height*0.522, 100, 100);

      fill(255);
      rect(width*0.275, height*0.5, width*0.225, height*0.45, 10, 10, 10, 10);
      rect(width*0.75, height*0.5, width*0.225, height*0.45, 10, 10, 10, 10);

      fill(0);
      text(grafica1, width*0.26, height*0.475);
      if (idioma == "español") {
        text(grafica2, width*0.775, height*0.475);
      } else {
        text(grafica2, width*0.75, height*0.475);
      }
      
      fill(240);
      switch(selectop) {
      case 1:
        rect(width*0.285, height*0.525, width*0.2, height*0.0885, 10, 10, 10, 10);
        break;
      case 2:
        rect(width*0.285, height*0.625, width*0.2, height*0.0885, 10, 10, 10, 10);
        break;
      case 3:
        rect(width*0.285, height*0.725, width*0.2, height*0.0885, 10, 10, 10, 10);
        break;
      case 4:
        rect(width*0.285, height*0.825, width*0.2, height*0.0885, 10, 10, 10, 10);
        break;
      }

      switch(selectop2) {
      case 5:
        rect(width*0.76, height*0.525, width*0.2, height*0.0885, 10, 10, 10, 10);
        break;
      case 6:
        rect(width*0.76, height*0.625, width*0.2, height*0.0885, 10, 10, 10, 10);
        break;
      case 7:
        rect(width*0.76, height*0.725, width*0.2, height*0.0885, 10, 10, 10, 10);
        break;
      case 8:
        rect(width*0.76, height*0.825, width*0.2, height*0.0885, 10, 10, 10, 10);
        break;
      }

      if (mouseX >= width*0.285 && mouseX <= width*0.285 + width*0.2 && mouseY >= height*0.525 && mouseY <= height*0.525 + height*0.0885) {
        rect(width*0.285, height*0.525, width*0.2, height*0.0885, 10, 10, 10, 10);
        if (mousePressed && mouseButton == LEFT) {      
          selectop = 1;
          colorg1 = color(90, 130, 230);
          click.play();
          mousePressed = false;
          delay(5);
        }
      } else if (mouseX >= width*0.285 && mouseX <= width*0.285 + width*0.2 && mouseY >= height*0.625 && mouseY <= height*0.625 + height*0.0885) {
        rect(width*0.285, height*0.625, width*0.2, height*0.0885, 10, 10, 10, 10);
        if (mousePressed && mouseButton == LEFT) {   
          selectop = 2;
          colorg1 = color(255, 100, 100);
          click.play();
          mousePressed = false;
          delay(5);
        }
      } else if (mouseX >= width*0.285 && mouseX <= width*0.285 + width*0.2 && mouseY >= height*0.725 && mouseY <= height*0.725 + height*0.0885) {
        rect(width*0.285, height*0.725, width*0.2, height*0.0885, 10, 10, 10, 10);
        if (mousePressed && mouseButton == LEFT) {          
          selectop = 3;
          colorg1 = color(155, 155, 255);
          click.play();
          mousePressed = false;
          delay(5);
        }
      } else if (mouseX >= width*0.285 && mouseX <= width*0.285 + width*0.2 && mouseY >= height*0.825 && mouseY <= height*0.825 + height*0.0885) {
        rect(width*0.285, height*0.825, width*0.2, height*0.0885, 10, 10, 10, 10);
        if (mousePressed && mouseButton == LEFT) {       
          selectop = 4;
          colorg1 = color(100, 255, 100);
          click.play();
          mousePressed = false;
          delay(5);
        }
      }

      fill(0);
      text(azul, width*0.35, height*0.585);
      text(rojo, width*0.35, height*0.685);
      text(morado, width*0.35, height*0.785);
      text(verde, width*0.35, height*0.885);

      fill(240);
      if (mouseX >= width*0.76 && mouseX <= width*0.76 + width*0.2 && mouseY >= height*0.525 && mouseY <= height*0.525 + height*0.0885) {
        rect(width*0.76, height*0.525, width*0.2, height*0.0885, 10, 10, 10, 10);
        if (mousePressed && mouseButton == LEFT) {
          selectop2 = 5;
          colorg2 = color(90, 130, 230);
          click.play();
          mousePressed = false;
          delay(5);
        }
      } else if (mouseX >= width*0.76 && mouseX <= width*0.76 + width*0.2 && mouseY >= height*0.625 && mouseY <= height*0.625 + height*0.0885) {
        rect(width*0.76, height*0.625, width*0.2, height*0.0885, 10, 10, 10, 10);
        if (mousePressed && mouseButton == LEFT) {
          selectop2 = 6;
          colorg2 = color(255, 100, 100);
          click.play();
          mousePressed = false;
          delay(5);
        }
      } else if (mouseX >= width*0.76 && mouseX <= width*0.76 + width*0.2 && mouseY >= height*0.725 && mouseY <= height*0.725 + height*0.0885) {
        rect(width*0.76, height*0.725, width*0.2, height*0.0885, 10, 10, 10, 10);
        if (mousePressed && mouseButton == LEFT) {
          selectop2 = 7;
          colorg2 = color(155, 155, 255);
          click.play();
          mousePressed = false;
          delay(5);
        }
      } else if (mouseX >= width*0.76 && mouseX <= width*0.76 + width*0.2 && mouseY >= height*0.825 && mouseY <= height*0.825 + height*0.0885) {
        rect(width*0.76, height*0.825, width*0.2, height*0.0885, 10, 10, 10, 10);
        if (mousePressed && mouseButton == LEFT) {
          selectop2 = 8;
          colorg2 = color(100, 255, 100);
          click.play();
          mousePressed = false;
          delay(5);
        }
      }

      fill(0);
      text(azul, width*0.825, height*0.585);
      text(rojo, width*0.825, height*0.685);
      text(morado, width*0.825, height*0.785);
      text(verde, width*0.825, height*0.885);


      fill(90, 130, 230);
      circle(width*0.3, height*0.55, 30);
      fill(255, 100, 100);
      circle(width*0.3, height*0.65, 30);
      fill(155, 155, 255);
      circle(width*0.3, height*0.75, 30);
      fill(100, 255, 100);
      circle(width*0.3, height*0.85, 30);

      fill(90, 130, 230);
      circle(width*0.775, height*0.55, 30);
      fill(255, 100, 100);
      circle(width*0.775, height*0.65, 30);
      fill(155, 155, 255);
      circle(width*0.775, height*0.75, 30);
      fill(100, 255, 100);
      circle(width*0.775, height*0.85, 30);
      
      fill(255);
      triangle(width*0.612, height*0.57, width*0.612, height*0.63, width*0.65, (height*0.56+height*0.64)/2);
      if (mouseX >= width*0.575 && mouseX <= width*0.675 && mouseY >= height*0.522 && mouseY <= height*0.6825) {
        fill(0);
        triangle(width*0.612, height*0.57, width*0.612, height*0.63, width*0.65, (height*0.56+height*0.64)/2);
        over = true;
        if (mousePressed && mouseButton == LEFT) {
          simulador = true;
          ARDUINO = false;
          Info = false;
          pestana = true;
          click.play();
          mousePressed = false;
          background(240);
          s2=width*0.252;
          c2=0;
          x=0;
          x2=0;
        }
      }
      ellipseMode(CENTER);
    } else if (pestana == true) {
      fill(255);
      fill(240);
      rect(10, height*0.35, 240, 45, 10, 0, 0, 10);
      fill(0);
      text(sim, width*0.07, height*0.4);
      tint(90, 130, 230);
      image(simico, 20, height*0.36, 30, 30);
      tint(255);
      FORMULAS();
    }
  }
}
void FORMULAS() {
  vel = 331 + 0.6*temp;
  kelvin = temp + 273.15;   //convertir los grados a kelvin
  densidad = 28.977/(0.0821*kelvin);   //hallar la densidad formula sacada por relacion empirica
  periodo1 = 1/freq;
  k=(TWO_PI*freq)/vel;
  lambda = vel/freq;
  omega = lambda*freq*k;
  pmax = densidad*vel*omega*smax;
  angulo =(k*x)-(omega*t);
  angulo2 = (k*x2)-(omega*t);
  if (cambio==true) {
    if (freq >= 10000 && freq <= 20000) {
      x+=0.0001;
      x2+=0.0001;
    } else {
      if (freq >= 4500 && freq <= 9999) {
        x+=0.0003;
        x2+=0.0003;
      } else {
        if (freq >= 2500 && freq <= 4499) {
          x+=0.0005;
          x2+=0.0005;
        } else {
          if (freq >= 1500 && freq <= 2499) {
            x+=0.0007;
            x2+=0.0007;
          } else {
            if (freq >= 900 && freq <= 1499) {
              x+=0.0009;
              x2+=0.0009;
            } else {
              if (freq >= 300 && freq <= 899) {
                x+=0.005;
                x2+=0.005;
              } else {
                if (freq >= 150 && freq <= 299) {
                  x+=0.009;
                  x2+=0.009;
                } else {
                  if (freq >= 20 && freq <= 149) {
                    x+=0.02;
                    x2+=0.02;
                  }
                }
              }
            }
          }
        }
      }
    }
    for (cont=0; cont<3000; cont++) {
      if (freq >= 10000 && freq <= 20000) {
        s[cont]= map(pmax*sin(angulo2), 0, width, 0, 0.00156);
      }
      if (freq >= 4500 && freq <= 9999) {
        s[cont]= map(pmax*sin(angulo2), 0, width, 0, 0.0031);
      }
      if (freq >= 2500 && freq <= 4499) {
        s[cont]= map(pmax*sin(angulo2), 0, width, 0, 0.007);
      }
      if (freq >= 1500 && freq <= 2499) {
        s[cont]= map(pmax*sin(angulo2), 0, width, 0, 0.0125);
      }
      if (freq >= 900 && freq <= 1499) {
        s[cont]= map(pmax*sin(angulo2), 0, width, 0, 0.021);
      }
      if (freq >= 300 && freq <= 899) {
        s[cont]= map(pmax*sin(angulo2), 0, width, 0, 0.035);
      }
      if (freq >= 150 && freq <= 299) {
        s[cont]= map(pmax*sin(angulo2), 0, width, 0, 0.105);
      }
      if (freq >= 20 && freq <= 149) {
        s[cont]= map(pmax*sin(angulo2), 0, width, 0, 0.2);
      }
      p[cont]= map(smax*cos(angulo), 0, width, 0, 79000);
    }
    strokeWeight(5);
    stroke(0);
    line(width*0.252, height*0.25, width, height*0.25);
    if (boton) {
      line(width*0.252, height*0.75, width*0.75, height*0.75);
      stroke(0, 0, 0, 1);
      line(width*0.75, height*0.75, width, height*0.75);
    } else {
      line(width*0.252, height*0.75, width, height*0.75);
    }
    textSize(18);
    fill(0);
    text("S(m)", width*0.28, height*0.45);
    text("X(m)", width*0.95, height*0.45);
    text("P(Pa)", width*0.28, height*0.95);
    text("X(m)", width*0.95, height*0.95);
    strokeWeight(10);
    stroke(colorg1);
    point(s2, height*0.25 - s[c2]);
    stroke(colorg2);
    point(s2, height*0.75 - p[c2]);
  }
  imageMode(CENTER);
  image(oido, width*0.65 + width*0.235, height*0.75, 350, 350);
  translate(10, 0);
  armonico = map(smax*2, 10, 0, 10, 0)*sin((frameCount/(periodo/50))*TWO_PI);
  image(huesecillos, (width*0.65) + 230 + armonico, height*0.75, 350 + armonico, 350);
  tint(255);
  noStroke();
  fill(240);

  if (c2<2999) {
    c2=c2+1;
    s2=s2+1;
  }
}

void ARDUINO() {
  if (ARDUINO) {
    if (control == true) {
      background(240);
      plotcontrol = true;
      control = false;
    }
    println(serialdata);
    stroke(0);
    line(width*0.252, height/2, width, height/2);
    noStroke();
    fill(240);
    rect(10, height*0.45, 240, 45, 10, 0, 0, 10);
    fill(0);
    text("Arduino", width*0.07, height*0.5);
    tint(90, 130, 230);
    image(ARDico, 20, height*0.46, 30, 30);
    tint(255);
    pestana = false;
    if (nuevoData) {
      // Dibujando una linea desde el último dato serial hasta el nuevo.
      stroke(colorg1);     // color stroke
      strokeWeight(4);        // ancho del stroke
      line(ultimaxPos + width*0.252, height/2, xPos + width*0.252, height*0.5 - serialdata*0.7);
      line(ultimaxPos + width*0.252, height*0.5 + serialdata*0.7, xPos + width*0.252, height/2);
      ultimaxPos = xPos;
      ultimaaltura= int(height - serialdata);

      // Al borde de la ventana, se reinicia la gráfica:
      if (xPos == width || plotcontrol) {
        xPos = 0;
        ultimaxPos = 0;
        background(240);
        plotcontrol = false;
      } else {
        // Incrementa la posición horizontal:
        xPos++;
      }
      nuevoData =false;
    }
  }
}

void Info() {
  if (Info) {
    if (idioma == "español") {
      fill(240);
      rect(10, height*0.8, 240, 45, 10, 0, 0, 10);
      fill(0);
      text(info, width*0.07, height*0.845);
      tint(90, 130, 230);
      image(infoico, 20, height*0.81, 30, 30);
      tint(255);
      image(iespañol, width*0.25, 0);
      pestana=false;
    } else {
      fill(240);
      rect(10, height*0.8, 240, 45, 10, 0, 0, 10);
      fill(0);
      text(info, width*0.07, height*0.845);
      tint(90, 130, 230);
      image(infoico, 20, height*0.81, 30, 30);
      tint(255);
      image(iingles, width*0.25, 0);
      pestana=false;
    }
  }
}

float mouseDragged(float maxX, float minX, float posmin, float posmax) {
  if ( mousePressed && mouseY >= height*0.215 && mouseY <=height*0.285 && mouseX<=maxX && mouseX >= minX ) {
    dragX = mouseX - minX;
    if (dragX <= posmin) {
      dragX=  posmin ;
    }
    if (dragX >= posmax) {
      dragX=  posmax ;
    }
  }
  return(dragX);
}

// Mover slider temperatura
float movertemp(float Xmax, float Xmin) {
  if ( mousePressed && mouseY >= height*0.215 && mouseY <=height*0.285 && mouseX<=Xmax && mouseX >= Xmin ) {
    Xdrag = mouseX;
    if (Xdrag <= Xmin) {
      Xdrag=  Xmin ;
    }
    if (Xdrag >= Xmax) {
      Xdrag = Xmax;
    }
  }
  return(Xdrag);
}

// Incrementar tamaño slider amplitud
float tamaño(float posmax, float posmin) {
  if ( mousePressed && mouseY >= height*0.215 && mouseY <=height*0.285 && mouseX<=posmax && mouseX >= posmin ) {
    tamaño=(mouseX-width*0.54)* width*0.0001+ width*0.008;
  }
  return(tamaño);
}

//Mover slider frecuencia
float fecuencia(float wmax, float wmin) {
  if (mousePressed && mouseY >= height*0.215 && mouseY <=height*0.285 && mouseX<=wmax && mouseX >= wmin) {
    moverx=mouseX;
  }
  return(moverx);
}

void serialEvent (Serial puerto) {
  // Obtiene el string ASCII:
  String inString = puerto.readStringUntil('\n');
  if (inString != null) {
    inString = trim(inString);                              // Recorta los espacios en blanco.
    serialdata = float(inString);                           // Convierte a variable float.
    serialdata = map(serialdata, 0, 1023, 0, height*0.9);   // Se mapea a la altura de la pantalla.
    nuevoData = true;
  }
}
