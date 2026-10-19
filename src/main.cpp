#include <glad/glad.h> /* Glad must me included before any other library that uses OpenGL! */
#include <gl/gl.h>
#include <GLFW/glfw3.h>

#include <iostream>
#include <cstddef>

#define WINDOW_WIDTH 800
#define WINDOW_HEIGHT 600

void framebuffer_size_callback(GLFWwindow *window, int width, int height);
void processInput(GLFWwindow *window);

int main()
{
    /* start GLFW and tell it to use OpenGL v3.3 with the Core-Profile */
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

    /* create a window */
    GLFWwindow *window = glfwCreateWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Learn OpenGL", NULL, NULL);
    if (window == NULL)
    {
        std::cout << "Failed to create a window." << std::endl;
        glfwTerminate();
        return -1;
    }
    glfwMakeContextCurrent(window); /* setting the current OpenGL context to be the window */

    /* initialize GLAD so we can have access to OpenGL functions (pointer) */
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
    {
        std::cout << "Failed to initialize GLAD" << std::endl;
        return -1;
    }

    /* telling OpenGL the size of the rendering area (out window) */
    glViewport(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);

    /* tell GLFW to call the resize callback function everytime we resize the window */
    glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);

    /* render loop */
    while (!glfwWindowShouldClose(window))
    {
        /* INPUT */
        processInput(window);

        /* RENDER */
        glClearColor(0.39f, 0.58f, 0.93f, 1.0f); /* clear the frame with CornflowerBlue */
        glClear(GL_COLOR_BUFFER_BIT); /* set the entire buffer color to whatever was passed to glClearColor() */

        /* BUF SWAP & EVENT CHECKING */
        glfwPollEvents();        /* listen to window events and maybe call some callbacks */
        glfwSwapBuffers(window); /* double buffering (swap the back buffer with the front buffer) */
    }

    /* close/delete GLFW shit before we close the app */
    glfwTerminate();
    return 0;
}

/* GLFW will call this function everytime we resize the window so it can update the OpenGL viewport */
#ifdef __clang__

#pragma clang diagnostic push /* that's to keep my sanity :) */
#pragma clang diagnostic ignored "-Wunused-parameter"

#endif /* __CLANG__ */
void framebuffer_size_callback(GLFWwindow *window, int width, int height)
{
    glViewport(0, 0, width, height);
}
#ifdef __clang__

#pragma clang diagnostic pop

#endif /* __CLANG__ */

void processInput(GLFWwindow *window)
{
    /* if I pressed "esc" glfwGetKey() will return GLFW_PRESS
     * and if NOT it will return GLFW_RELEASE
     */
    if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
        glfwSetWindowShouldClose(window, true);
}
