package id.sevatech.poscafe

import org.junit.Assert.*
import org.junit.Before
import org.junit.Test

/**
 * Unit tests untuk logika Android native Coffee Shop POS.
 *
 * Jalankan dengan: ./gradlew :app:testDebugUnitTest
 */
class MainActivityTest {

    // ── Helper: validasi cartId ───────────────────────────────────────────

    /** CartId valid: non-empty dan tidak mengandung spasi. */
    private fun isValidCartId(cartId: String): Boolean {
        return cartId.isNotBlank() && !cartId.contains(" ")
    }

    // ── Helper: hitung kembalian ──────────────────────────────────────────

    /** Menghitung kembalian dari uang diterima dan total tagihan. */
    private fun calculateChange(received: Double, total: Double): Double {
        return received - total
    }

    // ── Helper: validasi role ─────────────────────────────────────────────

    private val validRoles = listOf("Owner", "Manager", "Cashier")

    /** Memvalidasi apakah role termasuk dalam daftar role yang diizinkan. */
    private fun isValidRole(role: String): Boolean {
        return role in validRoles
    }

    // ── Helper: format nama pelanggan ─────────────────────────────────────

    /** Mengembalikan "Guest" apabila nama kosong, selain itu mengembalikan nama. */
    private fun resolveCustomerName(name: String): String {
        return name.ifBlank { "Guest" }
    }

    // ── Helper: validasi metode pembayaran ────────────────────────────────

    private val validPaymentMethods = listOf("Cash", "QRIS")

    private fun isValidPaymentMethod(method: String): Boolean {
        return method in validPaymentMethods
    }

    // ─────────────────────────────────────────────────────────────────────
    // Test Cases — isValidCartId
    // ─────────────────────────────────────────────────────────────────────

    @Test
    fun `cartId yang valid mengembalikan true`() {
        assertTrue(isValidCartId("cart-abc-001"))
    }

    @Test
    fun `cartId kosong mengembalikan false`() {
        assertFalse(isValidCartId(""))
    }

    @Test
    fun `cartId hanya spasi mengembalikan false`() {
        assertFalse(isValidCartId("   "))
    }

    @Test
    fun `cartId dengan spasi di tengah mengembalikan false`() {
        assertFalse(isValidCartId("cart id 001"))
    }

    // ─────────────────────────────────────────────────────────────────────
    // Test Cases — calculateChange
    // ─────────────────────────────────────────────────────────────────────

    @Test
    fun `kembalian dihitung dengan benar`() {
        val change = calculateChange(received = 100_000.0, total = 75_000.0)
        assertEquals(25_000.0, change, 0.001)
    }

    @Test
    fun `kembalian nol saat uang pas`() {
        val change = calculateChange(received = 50_000.0, total = 50_000.0)
        assertEquals(0.0, change, 0.001)
    }

    @Test
    fun `kembalian negatif saat uang kurang (underpayment)`() {
        val change = calculateChange(received = 40_000.0, total = 50_000.0)
        assertTrue(change < 0)
    }

    // ─────────────────────────────────────────────────────────────────────
    // Test Cases — isValidRole
    // ─────────────────────────────────────────────────────────────────────

    @Test
    fun `role Owner valid`() {
        assertTrue(isValidRole("Owner"))
    }

    @Test
    fun `role Manager valid`() {
        assertTrue(isValidRole("Manager"))
    }

    @Test
    fun `role Cashier valid`() {
        assertTrue(isValidRole("Cashier"))
    }

    @Test
    fun `role tidak dikenal mengembalikan false`() {
        assertFalse(isValidRole("Admin"))
    }

    @Test
    fun `role kosong mengembalikan false`() {
        assertFalse(isValidRole(""))
    }

    @Test
    fun `role dengan huruf kecil mengembalikan false (case-sensitive)`() {
        assertFalse(isValidRole("cashier"))
    }

    // ─────────────────────────────────────────────────────────────────────
    // Test Cases — resolveCustomerName
    // ─────────────────────────────────────────────────────────────────────

    @Test
    fun `nama pelanggan yang valid dikembalikan apa adanya`() {
        assertEquals("Budi Santoso", resolveCustomerName("Budi Santoso"))
    }

    @Test
    fun `nama pelanggan kosong dikembalikan sebagai Guest`() {
        assertEquals("Guest", resolveCustomerName(""))
    }

    @Test
    fun `nama pelanggan hanya spasi dikembalikan sebagai Guest`() {
        assertEquals("Guest", resolveCustomerName("   "))
    }

    // ─────────────────────────────────────────────────────────────────────
    // Test Cases — isValidPaymentMethod
    // ─────────────────────────────────────────────────────────────────────

    @Test
    fun `metode pembayaran Cash valid`() {
        assertTrue(isValidPaymentMethod("Cash"))
    }

    @Test
    fun `metode pembayaran QRIS valid`() {
        assertTrue(isValidPaymentMethod("QRIS"))
    }

    @Test
    fun `metode pembayaran tidak dikenal mengembalikan false`() {
        assertFalse(isValidPaymentMethod("Kartu Kredit"))
    }

    @Test
    fun `metode pembayaran kosong mengembalikan false`() {
        assertFalse(isValidPaymentMethod(""))
    }
}
