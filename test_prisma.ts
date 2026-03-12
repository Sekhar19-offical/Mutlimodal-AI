
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

async function main() {
    try {
        const userCount = await prisma.users.count()
        print('DATABASE CONNECTED! User count:', userCount)
        const users = await prisma.users.findMany()
        for (const user of users) {
            print('User found:', user.email)
        }
    } catch (e) {
        print('ERROR:', e.message)
    } finally {
        await prisma.$disconnect()
    }
}

main()
