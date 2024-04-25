CREATE DATABASE Prueba;

USE Prueba;

-- Parte 1 --

-- Punto 1: Crear modelo y tablas

CREATE TABLE peliculas (
                           id INT PRIMARY KEY AUTO_INCREMENT,
                           name VARCHAR(255) NOT NULL ,
                           year INT NOT NULL
);

CREATE TABLE tags (
                      id INT AUTO_INCREMENT PRIMARY KEY,
                      tag VARCHAR(32)
);


CREATE TABLE vinculadas (
                            id_peliculas INT NOT NULL,
                            id_tags INT NOT NULL,
                            FOREIGN KEY (id_peliculas) REFERENCES peliculas(id),
                            FOREIGN KEY (id_tags) REFERENCES tags(id)
);

-- Punto 2: Insertar películas y tags

INSERT INTO peliculas (name, year)
VALUES           ('Casablanca', 1942),
                 ('Nosferatu', 1922 ),
                 ('Los 400 golpes', 1959),
                 ('Requiem for a dream', 2000),
                 ('El niño y la garza', 2023);

INSERT INTO tags (tag)
VALUES           ('Cine clasico'),
                 ('Cine moderno'),
                 ('Cine contemporaneo'),
                 ('blanco y negro'),
                 ('Drama');

INSERT INTO vinculadas (id_peliculas, id_tags)
VALUES                  (1,1),
                        (1,4),
                        (1,5),
                        (2,1),
                        (2,4),
                        (3,2),
                        (4,3),
                        (4,5);

-- Punto 3: Cantidad de tags por película

SELECT peliculas.id,
       peliculas.name,
       COUNT(vinculadas.id_tags) AS cantidad_tags
FROM peliculas
         LEFT JOIN vinculadas ON peliculas.id = vinculadas.id_peliculas
GROUP BY peliculas.id, peliculas.name;

-- Parte 2 --

-- Punto 4: Crear tablas
CREATE TABLE preguntas(
                          id INT PRIMARY KEY AUTO_INCREMENT,
                          pregunta VARCHAR(255) NOT NULL,
                          respuesta_correcta VARCHAR(255) NOT NULL
);

CREATE TABLE usuarios(
                         id INT PRIMARY KEY AUTO_INCREMENT,
                         nombre VARCHAR(255) NOT NULL,
                         edad INT NOT NULL
);

CREATE TABLE respuestas(
                           id INT PRIMARY KEY AUTO_INCREMENT,
                           respuesta VARCHAR(255) NOT NULL,
                           usuario_id INT NOT NULL,
                           FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
                           pregunta_id INT NOT NULL,
                           FOREIGN KEY (pregunta_id) REFERENCES preguntas(id)
);

-- Punto 5: Agregar registros a tablas

INSERT INTO preguntas(pregunta, respuesta_correcta)
VALUES ('¿Qué fue primero, el huevo o la gallina?', 'El pollo'),
       ('¿Cuál es el significado de la vida?', '42'),
       ('¿Tangananica o Tangananá?', 'Tangananá'),
       ('¿Team frío o team calor?', 'Team frío'),
       ('¿Rancagua existe?', 'No');

INSERT INTO usuarios(nombre, edad)
VALUES ('Yoan Zhuang', 3000),
       ('Sandía Perro', 9000);

INSERT INTO respuestas(respuesta, usuario_id, pregunta_id)
VALUES ('El pollo', 1, 1),
       ('El pollo', 2, 1),
       ('42', 1, 2),
       ('Guau', 2, 2),
       ('Tinguiririca', 1, 3),
       ('Tangananica',2, 3),
       ('Ninguno',1, 4),
       ('Team otoño',2, 4),
       ('Sí',1, 5),
       ('Dicen que no. Guau',2, 5);

-- Punto 6: Respuestas correctas totales por usuario

SELECT u.nombre, COUNT(r.respuesta) AS cantidad_respuestas_correctas
FROM respuestas r
         INNER JOIN preguntas p ON r.pregunta_id = p.id AND r.respuesta = p.respuesta_correcta
         INNER JOIN usuarios u ON r.usuario_id = u.id
GROUP BY u.id;

-- Punto 7: Respuesta correcta por pregunta

SELECT p.respuesta_correcta, COUNT(r.id) AS CRCP
FROM Preguntas p
         LEFT JOIN Respuestas r ON r.pregunta_id = p.id AND r.respuesta = p.respuesta_correcta
GROUP BY p.respuesta_correcta;

-- Punto 8: Borrado en cascada

ALTER TABLE respuestas
    ADD CONSTRAINT fk_usuario
        FOREIGN KEY (usuario_id)
            REFERENCES usuarios(id)
            ON DELETE CASCADE;

DELETE FROM usuarios WHERE id = 1;

-- Punto 9: Crear restricción de edad

ALTER TABLE usuarios ADD CONSTRAINT chk_edad CHECK (edad >= 18);

INSERT INTO usuarios(nombre, edad)
VALUES ('Chango Lango', 5);

-- Punto 10: Agregar campo email

ALTER TABLE usuarios ADD COLUMN email VARCHAR(50) UNIQUE;