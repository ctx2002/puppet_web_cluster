<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\HttpFoundation\Response;

class HelloController extends AbstractController
{
    /**
     * @Route("/hello", name="hello")
     */
    public function index()
    {
		return $this->render('hello/index.html.twig', [
            'controller_name' => 'HelloController',
        ]);
    }

    /**
     * @Route("/check", name="check")
     */

    public function check()
    {
        return new Response(
            '<html><body>done</body></html>'
        );
    }
}
