package br.com.plazaz.barbicha

import org.junit.runners.Suite.SuiteClasses
import org.junit.runners.Suite
import org.junit.runner.RunWith


@RunWith(Suite::class)
@SuiteClasses(TestAppInitialization::class, TestBarbershopModel::class)
class AllTests