void fillPolygon(Point* polygon, int numVertices, Pixel color) {
    int i, j, k;
    int minY = HEIGHT, maxY = 0;

    // Find the bounding box of the polygon
    for (i = 0; i < numVertices; i++) {
        if (polygon[i].y < minY) minY = polygon[i].y;
        if (polygon[i].y > maxY) maxY = polygon[i].y;
    }

    // Process each scanline within the bounding box
    for (i = minY; i <= maxY; i++) {
        int intersections[100]; // Array to store intersection points
        int count = 0;

        // Find intersections with the polygon edges
        for (j = 0; j < numVertices; j++) {
            int k = (j + 1) % numVertices;
            int y0 = polygon[j].y;
            int y1 = polygon[k].y;

            if (y0 < y1) {
                if (i >= y0 && i <= y1) {
                    int x = polygon[j].x + (i - y0) * (polygon[k].x - polygon[j].x) / (y1 - y0);
                    intersections[count++] = x;
                }
            } else if (y0 > y1) {
                if (i >= y1 && i <= y0) {
                    int x = polygon[k].x + (i - y1) * (polygon[j].x - polygon[k].x) / (y0 - y1);
                    intersections[count++] = x;
                }
            }
        }

        // Sort the intersection points
        for (j = 0; j < count - 1; j++) {
            for (k = j + 1; k < count; k++) {
                if (intersections[j] > intersections[k]) {
                    int temp = intersections[j];
                    intersections[j] = intersections[k];
                    intersections[k] = temp;
                }
            }
        }

        // Fill between pairs of intersections
        for (j = 0; j < count; j += 2) {
            int x0 = intersections[j];
            int x1 = intersections[j + 1];
            for (k = x0; k <= x1; k++) {
                setPixel(k, i, color);
            }
        }
    }
}

Point polygon[] = {{50, 10}, {10, 90}, {90, 90}};
int numVertices = sizeof(polygon) / sizeof(polygon[0]);

// Fill the polygon with a color
Pixel color = {255, 0, 0}; // Red color
fillPolygon(polygon, numVertices, color);