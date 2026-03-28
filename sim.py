#!/usr/bin/env python3
import itertools
import json
import socket
import time

import pygame

SCREEN_SIZE = 24
PIXEL_SIZE = 30
PIXEL_RADIUS_RATIO = 0.6

pygame.init()

screen = pygame.display.set_mode((PIXEL_SIZE * SCREEN_SIZE, PIXEL_SIZE * SCREEN_SIZE))
pygame.display.set_caption("Game of Life - Croix Simulator")
clock = pygame.time.Clock()
font = pygame.font.Font(None, 24)

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(("0.0.0.0", 1337))
sock.setblocking(False)

frame = [[0 for _ in range(24)] for _ in range(24)]
generation = 0
start_time = time.time()
last_population = 0


def is_drawable(r, c):
    panel = (r // 8, c // 8)
    return panel in ((0, 1), (1, 0), (1, 1), (1, 2), (2, 1))


def get_cell_color(val):
    if val <= 0:
        return (0, 0, 0)
    ratio = val / 7.0
    red = int(20 * ratio)
    green = int(255 * ratio)
    blue = int(80 * ratio)
    return (red, green, blue)


while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            raise SystemExit

    try:
        data, _ = sock.recvfrom(65535)
        frame = json.loads(data.decode())
        generation += 1
        last_population = sum(sum(1 for v in row if v > 0) for row in frame)
    except (BlockingIOError, socket.error, json.JSONDecodeError):
        pass

    screen.fill((5, 5, 10))

    for r, c in itertools.product(range(24), repeat=2):
        if not is_drawable(r, c):
            continue
        val = frame[r][c]
        if val <= 0:
            continue

        color = get_cell_color(val)
        x = int(PIXEL_SIZE * (c + 0.5))
        y = int(PIXEL_SIZE * (r + 0.5))
        radius = int(PIXEL_SIZE * PIXEL_RADIUS_RATIO / 2)

        glow_color = tuple(channel // 3 for channel in color)
        pygame.draw.circle(screen, glow_color, (x, y), radius + 2, 1)
        pygame.draw.circle(screen, color, (x, y), radius)

    elapsed = time.time() - start_time
    fps = generation / elapsed if elapsed > 0 else 0.0

    stats_text = f"Gen: {generation} | Pop: {last_population:3d} | FPS: {fps:.1f}"
    text_surface = font.render(stats_text, True, (100, 220, 100))
    screen.blit(text_surface, (10, 10))

    pygame.display.flip()
    clock.tick(60)
